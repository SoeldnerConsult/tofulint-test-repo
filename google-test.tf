 #incorrect override strategy
resource "google_app_engine_domain_mapping" "domain_mapping" {
  domain_name       = "verified-domain.com"
  override_strategy = "STRICT"

  ssl_settings {
    ssl_management_type = "AUTOMATIC"
  }
}

 #invalid machine type
resource "google_compute_instance" "vm_instance" {
  machine_type = "e2-micro" 
}

 #invalid member format
resource "google_project_iam_audit_config" "iam_audit_config" {
	audit_log_config {
		exempted_members = [
			"user:arsiba@example.com",
		]
	}
}