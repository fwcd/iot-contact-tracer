enum HealthStatus {
  healthy,
  exposed,
  unknown
}

extension HealthStatusLabel on HealthStatus {
  String get label {
    switch (this) {
      case HealthStatus.healthy:
        return "Healthy";
      case HealthStatus.exposed:
        return "Exposed";
      case HealthStatus.unknown:
        return "Unknown";
    }
  }
}
