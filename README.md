# CS:APP Dev Env

A tool for provisioning and managing cloud dev environments. This project is intended to be used for problems,  examples, and exploration while working through [Computer Systems: A Programmer's Perspective](https://csapp.cs.cmu.edu/).

The dev environment is a Linux (Ubuntu) x86_64 EC2 instance.

The instance currently includes:
* [`gcc`](https://gcc.gnu.org/) and [`make`](https://www.gnu.org/software/make/) (via [build-essential](https://packages.ubuntu.com/jammy/build-essential))
* [Rust](https://www.rust-lang.org/)
* [Neovim](https://neovim.io/) with some [configuration](https://gist.github.com/CDThomas/3532c223ee44383e991b3ee991df6866).

## Prerequisites

This project uses the Terraform CLI and AWS to provision dev environments. To create an environment, you'll need to have the [Terraform CLI](https://www.terraform.io/cli) and [AWS CLI](https://aws.amazon.com/cli/) installed locally.

You can also optionally use [`direnv`](https://direnv.net/) for local env var management.

For convenience this project includes a [`.tool-versions`](./.tool-versions) for installation via [asdf](https://asdf-vm.com/).

The environment will be provisioned in AWS, so you'll also need to have an AWS account.

## Usage

### Configuration

First, make sure that your AWS credentials are available in your env.

For example (using a `.envrc` with `direnv`):
```
export AWS_ACCESS_KEY_ID=anaccesskey
export AWS_SECRET_ACCESS_KEY=asecretkey
```

You'll also need to have an existing SSH key pair in AWS to use to access the dev env. The docs for creating a key pair in AWS are [here](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/create-key-pairs.html).

You can specify the name of the key to use either in a `terraform.tfvars` file or in your env.

Environment example:
```
export TF_VAR_aws_ssh_key_name=yourkeyname
```

`terraform.tfvars` example:
```
aws_ssh_key_name = "yourkeyname"
```

### Scripts

Managing the environment happens via scripts that can be found in the [`bin` directory](./bin/).

The scripts are:
* `create`: creates the environment
  * Example usage: `./bin/create`
* `connect`: connects to the environment via SSH
  * Example usage: `./bin/connect`
* `destroy`: destroys the environment
  * Example usage: `./bin/destroy`
* `recreate`: recreates (destroys and then creates) the environment
  * Example usage: `./bin/recreate`
