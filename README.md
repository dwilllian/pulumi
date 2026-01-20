# Terraform GCP Hub & Spoke (Prod-Ready)

Este repositório cria uma arquitetura **Hub & Spoke** na Google Cloud com GKE e VM no spoke DEV, seguindo boas práticas e idempotência.

## Estrutura

```
.
├── bootstrap/
├── modules/
├── envs/
│   ├── hub/
│   ├── dev/
│   ├── hml/
│   └── prod/
└── README.md
```

## Diagrama (ASCII)

```
                  ┌────────────────────────────┐
                  │          HUB VPC           │
                  │  - Subnets (regional)      │
                  │  - Cloud NAT (opcional)    │
                  │  - Firewall (deny ingress) │
                  └─────────────┬──────────────┘
                                │
                 ┌──────────────┼──────────────┐
                 │              │              │
         ┌───────▼───────┐┌─────▼───────┐┌─────▼───────┐
         │   SPOKE DEV   ││  SPOKE HML  ││  SPOKE PROD │
         │  - Subnets    ││  - Subnets  ││  - Subnets  │
         │  - GKE basic  ││  - Firewall ││  - Firewall │
         │  - VM basic   ││  - NCC/peer ││  - NCC/peer │
         └───────────────┘└─────────────┘└─────────────┘
```

## Pré-requisitos

- Terraform **>= 1.6**
- Provider Google **>= 5.x** (compatível com 7.x)
- Credenciais configuradas (`GOOGLE_APPLICATION_CREDENTIALS` ou ADC)

## Ordem de execução (obrigatória)

1. **Bootstrap** (cria projeto e bucket de state)
2. **Hub**
3. **Dev**
4. **Hml**
5. **Prod**

## Bootstrap

```bash
cd bootstrap
terraform init
terraform plan -var-file=bootstrap.tfvars
terraform apply -var-file=bootstrap.tfvars
```

## Hub

```bash
cd envs/hub
terraform init -backend-config="bucket=<STATE_BUCKET>" -backend-config="prefix=envs/hub"
terraform plan -var-file=hub.tfvars
terraform apply -var-file=hub.tfvars
```

## Dev

```bash
cd envs/dev
terraform init -backend-config="bucket=<STATE_BUCKET>" -backend-config="prefix=envs/dev"
terraform plan -var-file=dev.tfvars
terraform apply -var-file=dev.tfvars
```

## HML

```bash
cd envs/hml
terraform init -backend-config="bucket=<STATE_BUCKET>" -backend-config="prefix=envs/hml"
terraform plan -var-file=hml.tfvars
terraform apply -var-file=hml.tfvars
```

## Prod

```bash
cd envs/prod
terraform init -backend-config="bucket=<STATE_BUCKET>" -backend-config="prefix=envs/prod"
terraform plan -var-file=prod.tfvars
terraform apply -var-file=prod.tfvars
```

## Observações importantes

- Todos os valores são fornecidos via **.tfvars** (sem hardcode nos `.tf`).
- Para conectividade, o padrão é **NCC**; se `use_ncc=false`, o fallback é **VPC Peering**.
- Firewalls suportam `target_tags` **ou** `target_service_accounts` (mutuamente exclusivos).
- GKE e VM no **DEV** dependem explicitamente da criação de rede/subnets/firewall.
