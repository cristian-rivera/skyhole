# SkyHole

The goal of this project is to provide cloud resources consisting of OpenVPN and Pi-hole. When applying this configuration on your AWS account, within minutes, you will have a dedicated VPC running a hardened OpenVPN server, which directs its clients to use a newly created Pi-hole server for all DNS queries.

Both OpenVPN and Pi-hole servers inherit dedicated IP addresses along with pre-configured firewall rules. Also, if you would like to SSH into either server, the SSH keys are provided in this directory upon successful creation. These keys should not be checked in to source control and are ignored by default along with Terraform state files.

## Getting Started

Configure AWS:

```bash
$ export AWS_ACCESS_KEY_ID=""
$ export AWS_SECRET_ACCESS_KEY=""
```

Run Terraform:

```bash
$ terraform apply
```

Once Terraform has successfully applied the configuration, a `client.ovpn` file will appear in this directory. Import this file to any OpenVPN client. That's it.

## Connecting via SSH

When connected using an OpenVPN client:

OpenVPN:

```bash
$ ssh -i "private_key.pem" ubuntu@10.0.1.0
```

Pi-hole:

```bash
$ ssh -i "private_key.pem" ubuntu@10.0.1.1
```

## Accessing the Pi-hole Web Interface

When connected using an OpenVPN client, navigate to [http://pi.hole](http://pi.hole).

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| domain\_name\_servers | n/a | `list(string)` | <pre>[<br>  "1.1.1.1",<br>  "1.0.0.1"<br>]</pre> | no |
| name | n/a | `string` | `"SkyHole"` | no |
| openvpn\_ami | n/a | `string` | `"ami-04b9e92b5572fa0d1"` | no |
| openvpn\_instance\_type | n/a | `string` | `"t3.nano"` | no |
| openvpn\_private\_ip | n/a | `string` | `"10.0.1.0"` | no |
| openvpn\_subnet\_cidr\_block | n/a | `string` | `"10.0.2.0/24"` | no |
| pi-hole\_ami | n/a | `string` | `"ami-04b9e92b5572fa0d1"` | no |
| pi-hole\_instance\_type | n/a | `string` | `"t3.nano"` | no |
| pi-hole\_private\_ip | n/a | `string` | `"10.0.1.1"` | no |
| region | n/a | `string` | `"us-east-1"` | no |
| subnet\_cidr\_block | n/a | `string` | `"10.0.0.0/20"` | no |
| vpc\_cidr\_block | n/a | `string` | `"10.0.0.0/16"` | no |

## Outputs

| Name | Description |
|------|-------------|
| openvpn\_private\_ip | n/a |
| openvpn\_public\_ip | n/a |
| pi-hole\_private\_ip | n/a |
| pi-hole\_public\_ip | n/a |

## Contributing

Everyone is encouraged to help improve this project. Here are a few ways you can help:

- Suggest or add new features
- Write, clarify, or fix documentation
- [Report bugs](https://github.com/cristian-rivera/skyhole/issues)
- Fix bugs and [submit pull requests](https://github.com/cristian-rivera/skyhole/pulls)
