import pulumi
import pulumi_awsx as awsx
import pulumi_eks as eks
import pulumi_aws as aws

# Get some values from the Pulumi configuration (or use defaults)
config = pulumi.Config()
min_cluster_size = config.get_float("minClusterSize", 3)
max_cluster_size = config.get_float("maxClusterSize", 6)
desired_cluster_size = config.get_float("desiredClusterSize", 3)
eks_node_instance_type = config.get("eksNodeInstanceType", "t3.medium")
vpc_network_cidr = config.get("vpcNetworkCidr", "10.0.0.0/16")

# Create a VPC for the EKS cluster
eks_vpc = awsx.ec2.Vpc("vpc-facepass",
    enable_dns_hostnames=True,
    cidr_block=vpc_network_cidr)

# Create the EKS cluster
eks_cluster = eks.Cluster("eks-facepass",
    vpc_id=eks_vpc.vpc_id,
    public_subnet_ids=eks_vpc.public_subnet_ids,
    private_subnet_ids=eks_vpc.private_subnet_ids,
    instance_type=eks_node_instance_type,
    desired_capacity=desired_cluster_size,
    min_size=min_cluster_size,
    max_size=max_cluster_size,
    node_associate_public_ip_address=False
    )

bucket = aws.s3.Bucket('alb-log-bucket')

# Create an Application Load Balancer (ALB)
alb = aws.lb.LoadBalancer("alb-facepass",
    security_groups=[eks_vpc.vpc.default_security_group_id],   # Assign the VPC security group
    subnets=eks_vpc.public_subnet_ids,  # Use the VPC public subnet IDs
    enable_http2=True,
    access_logs=aws.lb.LoadBalancerAccessLogsArgs(
        bucket=bucket.id,
        enabled=True,
        prefix="alb-logs"
    )
)

# Replace awsx.lb.TargetGroup with aws.lb.TargetGroup
tgt_group_args = aws.lb.TargetGroupArgs(
    port=80,
    protocol='HTTP',
    health_check=aws.lb.TargetGroupHealthCheckArgs(
        enabled=True,
        path='/',
        protocol='HTTP'
    ),
    vpc_id=eks_vpc.id
)

# Replace awsx.lb.TargetGroup with aws.lb.TargetGroup
tgt_group = aws.lb.TargetGroup('tgt-group', args=tgt_group_args)

listener_args = aws.lb.ListenerArgs(
    port=80,
    protocol='HTTP',
    default_actions=[aws.lb.ListenerDefaultActionArgs(  # wrap in a list to fix the error
        type='forward',
        target_group_arn=tgt_group.arn
    )],
    load_balancer_arn=alb.arn
)

listener = aws.lb.Listener('listener', args=listener_args)

pulumi.export("kubeconfig", eks_cluster.kubeconfig)
pulumi.export("vpcId", eks_vpc.id)
pulumi.export("albUrl", alb.dns_name)
pulumi.export("bucketName", bucket.id)