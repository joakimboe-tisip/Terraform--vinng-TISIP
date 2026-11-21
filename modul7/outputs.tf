
# Viser ID-en til subnettet som nettverksmodulen oppretter
output "subnet_id" {
  description = "ID-en til subnettet"
  value       = module.network.subnet_id
}
