# Usa una imagen base ligera
FROM kalilinux/kali-rolling

# Actualiza el sistema y las herramientas básicas
RUN apt-get update && apt-get install -y \
    build-essential \
    libssl-dev \
    libffi-dev \
    python3 \
    python3-dev \
    python3-pip

# Instala herramientas esenciales
RUN apt-get install -y aircrack-ng pciutils wireshark nmap john ettercap-text-only tcpdump net-tools iproute2

# Copia scripts personalizados al contenedor (opcional)
COPY scripts/ /tools

# Establece el directorio de trabajo
WORKDIR /tools

# Establece bash como shell por defecto
CMD ["/bin/bash"]
