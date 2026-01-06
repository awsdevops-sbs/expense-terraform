env=$1
action=$2

if [ -z "$env" ]; then
echo "input  dev\prod\stage\prod  is missing"
exit  1
fi

if [ -z "$action" ]; then
echo "input (plan/apply/init) is missing"
exit  1
fi

rm -rf ./terraform

terraform init -backend-config=env-$env/state.tfvars
terraform $action -var-file=env-$env/main.tf -auto-approve

