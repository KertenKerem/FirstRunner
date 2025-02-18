#!/bin/bash
# Script Configuration
NODE_EXPORTER_VERSION="1.8.2"
NODE_EXPORTER_TAR="node_exporter-$NODE_EXPORTER_VERSION.linux-amd64.tar.gz"
NODE_EXPORTER_URL="https://github.com/prometheus/node_exporter/releases/download/v$NODE_EXPORTER_VERSION/$NODE_EXPORTER_TAR"
INSTALL_DIR="/usr/local/bin"
USER="nodeexporter"
SERVICE_FILE="/lib/systemd/system/node_exporter.service"

# Detect OS
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
else
    echo "Unsupported operating system. Exiting."
    exit 1
fi

# Install prerequisites
install_prerequisites() {
    echo "Installing prerequisites..."
    if [[ "$OS" == "ubuntu" || "$OS" == "debian" ]]; then
        sudo apt update && sudo apt install -y wget tar
    elif [[ "$OS" == "rhel" || "$OS" == "centos" || "$OS" == "fedora" ]]; then
        sudo yum install -y wget tar
    else
        echo "Unsupported OS: $OS"
        exit 1
    fi
}

# Create node_exporter user
create_user() {
    echo "Creating $USER user..."
    if ! id -u $USER > /dev/null 2>&1; then
        sudo useradd --no-create-home --shell /bin/false $USER
    fi
}

# Download and install node_exporter
download_and_install() {
    echo "Downloading node_exporter... $NODE_EXPORTER_URL"
pause
    wget --no-check-certificate $NODE_EXPORTER_URL

    echo "Extracting node_exporter..."
    tar -xzf $NODE_EXPORTER_TAR
    sudo mv "node_exporter-$NODE_EXPORTER_VERSION.linux-amd64/node_exporter" $INSTALL_DIR

    echo "Setting permissions..."
    sudo chown $USER:$USER $INSTALL_DIR/node_exporter

#    echo "Cleaning up..."
#    rm -rf "node_exporter-$NODE_EXPORTER_VERSION.linux-amd64" $NODE_EXPORTER_TAR
}

# Create systemd service
setup_systemd_service() {
    echo "Setting up systemd service..."
    cat <<EOF | sudo tee $SERVICE_FILE > /dev/null
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=$USER
Group=$USER
Type=simple
ExecStart=$INSTALL_DIR/node_exporter

[Install]
WantedBy=multi-user.target
EOF

    echo "Reloading systemd daemon..."
    sudo systemctl daemon-reload
    echo "Enabling and starting node_exporter service..."
    sudo systemctl enable --now node_exporter
}

# Main Script Execution
install_prerequisites
create_user
download_and_install
setup_systemd_service

# Verify installation
echo "Checking node_exporter status..."
sudo systemctl status node_exporter --no-pager
