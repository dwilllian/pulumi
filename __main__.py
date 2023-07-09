import pulumi
from pulumi_aws import lb, s3
from pulumi_awsx import ec2
from pulumi_eks import Cluster
import pulumi_aws as aws

# Get some values from the Pulumi configuration (or use defaults)
config = pulumi.Config()
min_cluster_size = config.get_float("minClusterSize", 3)
max_cluster_size = config.get_float("maxClusterSize", 6)
desired_cluster_size = config.get_float("desiredClusterSize", 3)
eks_node_instance_type = config.get("eksNodeInstanceType", "t3.medium")
vpc_network_cidr = config.get("vpcNetworkCidr", "10.0.0.0/16")

# Create a VPC for the EKS cluster
eks_vpc = ec2.Vpc("vpc-facepass", cidr_block=vpc_network_cidr)

# Create the EKS cluster
eks_cluster = Cluster(
    "eks-facepass",
    version="1.20",  # Match your kubernetes version here
    vpc_id=eks_vpc.id,
    desired_capacity=desired_cluster_size,
    min_size=min_cluster_size,
    max_size=max_cluster_size,
    instance_type=eks_node_instance_type,
    node_associate_public_ip_address=False
)

# Create an S3 Bucket
bucket = s3.Bucket('alb-log-bucket')

alb_subnets = eks_vpc.public_subnet_ids.apply(lambda subnet_ids: [subnet.id for subnet in subnet_ids])

# Create an Application Load Balancer (ALB)
alb = lb.LoadBalancer(
    "alb-facepass",
    subnets=alb_subnets,
    access_logs=aws.lb.LoadBalancerAccessLogsArgs(
        bucket=bucket.id,
        enabled=True,
        prefix="alb-logs"
    )
)

# Create Target Group
tgt_group = lb.TargetGroup(
    'tgt-group',
    port=80,
    protocol='HTTP',
    vpc_id=eks_vpc.id
)

# Create Listener
listener = lb.Listener(
    'listener',
    load_balancer_arn=alb.arn,
    port=80,
    default_actions=[lb.ListenerDefaultActionArgs(
        type='forward',
        target_group_arn=tgt_group.arn
    )]
)

pulumi.export("kubeconfig", eks_cluster.kubeconfig)
pulumi.export("vpcId", eks_vpc.id)
pulumi.export("albUrl", alb.dns_name)
pulumi.export("bucketName", bucket.id)