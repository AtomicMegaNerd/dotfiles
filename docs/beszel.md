# Beszel Monitoring Guide

[Beszel](https://github.com/henrygd/beszel) is a lightweight, beautiful server monitoring platform
written in Go. It provides historical metrics, Docker/Podman container stats, and alerting with a
clean, modern UI.

---

## Architecture

Beszel consists of two components:

- **Hub:** The web dashboard and database (runs on `blahaj`).
- **Agent:** A lightweight daemon that collects system metrics (runs on each monitored machine).

For same-system monitoring, the Hub and Agent communicate via a shared Unix socket rather than TCP.

---

## NixOS Podman Configuration

Add the Hub and Agent containers to `virtualisation.oci-containers.containers` in
`configuration.nix`. Both containers share a socket directory on the host for local communication.

### Hub Container

The Hub stores all monitoring data and serves the web UI.

```nix
beszel-hub = {
  autoStart = true;
  image = "henrygd/beszel:latest";
  ports = [ "8090:8090/tcp" ];
  volumes = [
    "/var/lib/beszel/data:/beszel_data"
    "/var/lib/beszel/socket:/beszel_socket"
  ];
  environmentFiles = [ config.age.secrets.beszel-hub.path ];
  environment = {
    APP_URL = "http://localhost:8090";
  };
  extraOptions = [
    "--network=podman-ipv6"
  ];
};
```

### Agent Container (Local)

The agent uses `network_mode: host` and communicates with the hub via the shared Unix socket.

```nix
beszel-agent = {
  autoStart = true;
  image = "henrygd/beszel-agent:latest";
  volumes = [
    "/var/lib/beszel/agent:/var/lib/beszel-agent"
    "/var/lib/beszel/socket:/beszel_socket"
    "/var/run/podman/podman.sock:/var/run/docker.sock:ro"
  ];
  environment = {
    LISTEN = "/beszel_socket/beszel.sock";
    HUB_URL = "http://localhost:8090";
  };
  environmentFiles = [ config.age.secrets.beszel-agent.path ];
  extraOptions = [
    "--network=host"
  ];
};
```

---

## Setup Steps

### Create Agenix Secrets

Create a secret file for the Hub credentials:

```bash
agenix -e secrets/beszel-hub.age
```

Add the following content (using the exact variable names Beszel expects):

```text
USER_EMAIL=your-email@megaparsec.ca
USER_PASSWORD=your-secure-password
```

### Create tmpfiles for Data Directories

```nix
systemd.tmpfiles.rules = [
  "d /var/lib/beszel 0755 root root -"
  "d /var/lib/beszel/data 0755 root root -"
  "d /var/lib/beszel/socket 0755 root root -"
  "d /var/lib/beszel/agent 0755 root root -"
];
```

### Apply Configuration and Start Hub

Add the Hub container and secret to your configuration:

```nix
age.secrets = {
  # ... existing secrets
  beszel-hub.file = ../../secrets/beszel-hub.age;
};

virtualisation.oci-containers.containers = {
  # ... existing containers
  beszel-hub = {
    autoStart = true;
    image = "henrygd/beszel:latest";
    ports = [ "8090:8090/tcp" ];
    volumes = [
      "/var/lib/beszel/data:/beszel_data"
      "/var/lib/beszel/socket:/beszel_socket"
    ];
    environmentFiles = [ config.age.secrets.beszel-hub.path ];
    environment = {
      APP_URL = "http://localhost:8090";
    };
    extraOptions = [
      "--network=podman-ipv6"
    ];
  };
};
```

Deploy:

```bash
nh os rebuild .
```

The Hub will automatically create the admin account using the credentials from the secret.

### Get Agent Credentials from Hub UI

Log in to `http://blahaj:8090` and go to **Systems** → **Add System**. Name it `blahaj` and note the
**Key** and **Token** values.

### Create Agenix Secret for Agent

```bash
agenix -e secrets/beszel-agent.age
```

Contents:

```text
KEY=<public-key-from-hub>
TOKEN=<token-from-hub>
```

Add to configuration:

```nix
age.secrets.beszel-agent.file = ../../secrets/beszel-agent.age;
```

### Deploy Agent and Verify

```bash
nh os rebuild .
```

The Hub dashboard should show `blahaj` as **Online** within a few seconds.

---

## Firewall Configuration

Open the Hub port for internal access:

```nix
networking.firewall.allowedTCPPorts = [ 8090 ];
```

---

## Monitoring Other Machines

To monitor additional machines, run the Agent container on the target machine:

```bash
podman run -d --name beszel-agent \
  --network=host \
  --restart unless-stopped \
  -v ./beszel_agent_data:/var/lib/beszel-agent \
  -v /var/run/podman/podman.sock:/var/run/docker.sock:ro \
  -e LISTEN=45876 \
  -e HUB_URL=http://192.168.1.232:8090 \
  -e KEY=<your-key> \
  -e TOKEN=<your-token> \
  henrygd/beszel-agent:latest
```

Add the system in the Hub UI using the Key and Token shown when you created the system entry.

---

## Links

- [Beszel GitHub Repository](https://github.com/henrygd/beszel)
- [Beszel Official Documentation](https://beszel.dev)
- [Beszel Getting Started](https://beszel.dev/guide/getting-started)
- [Beszel Environment Variables](https://beszel.dev/guide/environment-variables)
- [Same-System Docker Compose Reference](https://github.com/henrygd/beszel/blob/main/supplemental/docker/same-system/docker-compose.yml)
