#!/bin/bash

# Colores para la terminal
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${CYAN}######################################################"
echo -e "#            INSTALADOR JAKIMONITOR OS              #"
echo -e "######################################################${NC}"

# Menú de opciones
echo -e "\n${YELLOW}Selecciona el tamaño del monitor:${NC}"
echo -e "1) Versión Titan (600px - Ultra Ancha)"
echo -e "2) Versión Compacta (550px - Recomendada)"
echo -e "3) Desinstalar monitor"
read -p "Selecciona una opción [1-3]: " opcion

if [ $opcion -eq 3 ]; then
    rm ~/.conkyrc
    sed -i '/alias jakion=/d' ~/.bashrc ~/.zshrc
    sed -i '/alias jakioff=/d' ~/.bashrc ~/.zshrc
    echo -e "${RED}[-] Monitor desinstalado correctamente.${NC}"
    exit
fi

# Definir ancho según elección
if [ $opcion -eq 1 ]; then
    WIDTH=600
    BAR=400
else
    WIDTH=550
    BAR=350
fi

# 1. Instalar dependencias necesarias
echo -e "${GREEN}[+] Instalando dependencias (Conky, Curl, Net-tools)...${NC}"
sudo apt update && sudo apt install conky-all curl lm-sensors net-tools -y

# 2. Crear el archivo de configuración .conkyrc en el HOME
echo -e "${GREEN}[+] Configurando interfaz visual ($WIDTH px)...${NC}"
cat << EOF > ~/.conkyrc
--[[
######################################################
# JAKIMONITOR OS v7.0 - THE TITAN EDITION            #
# Estilo: Ultra-Wide / Letras Grandes / Sin Empalmes #
######################################################
]]

conky.config = {
    alignment = 'top_right',
    background = true,
    border_width = 1,
    cpu_avg_samples = 2,
    default_color = '00FFFF',
    double_buffer = true,
    font = 'DejaVu Sans Mono:size=10',
    gap_x = 30,
    gap_y = 50,
    minimum_height = 1000,
    minimum_width = $WIDTH,
    own_window = true,
    own_window_transparent = true,
    own_window_argb_visual = true,
    own_window_type = 'desktop',
    own_window_hints = 'undecorated,below,sticky,skip_taskbar,skip_pager',
    update_interval = 1.0,
    use_xft = true,
    
    color1 = '00FFFF', -- Cyan
    color2 = '00FF00', -- Verde
    color3 = 'FF00FF', -- Magenta
    color4 = 'FFFFFF', -- Blanco
    color5 = 'FFFF00', -- Amarillo
}

conky.text = [[
\${alignc}\${color2}\${font DejaVu Sans Mono:bold:size=24}JakiMonitor OS\${font}
\${color1}\${hr 3}
\${color4}SISTEMA:\${goto 110}\${color1}\$nodename\${goto 290}\${color4}UPTIME:\${goto 390}\${color1}\$uptime
\${color4}KERNEL:\${goto 110}\${color1}\$kernel\${goto 290}\${color4}CARGA:\${goto 390}\${color3}\${loadavg}
\${color1}\${hr 1}

\${color2}\${font DejaVu Sans Mono:bold:size=12}🕵️ PRIVACIDAD Y SEGURIDAD DE RED\${font}
\${color4}ESTADO TOR:\${goto 150}\${color3}\${execi 10 (pgrep -x tor >/dev/null && echo "ONLINE") || echo "OFFLINE"}\${goto 310}\${color4}VPN (tun0):\${goto 420}\${color2}\${execi 10 (ip addr | grep tun0 >/dev/null && echo "ACTIVE") || echo "INACTIVE"}
\${color4}IP PÚBLICA:\${goto 150}\${color5}\${execi 3600 curl -s https://icanhazip.com}
\${color4}IP LOCAL:\${goto 150}\${color1}\${addr eth0}\${addr wlan0}\${addr ens33}
\${color4}GATEWAY:\${goto 150}\${color1}\$gw_ip\${goto 310}\${color4}DNS:\${goto 380}\${color1}\${execi 60 cat /etc/resolv.conf | grep nameserver | awk '{print \$2}' | head -n 1}
\${color4}CONEX. TCP:\${goto 150}\${color3}\${execi 5 netstat -ant | grep ESTABLISHED | wc -l} Activas\${goto 310}\${color4}CONEX. UDP:\${goto 420}\${color3}\${execi 5 netstat -au | wc -l} Activas
\${color1}\${hr 1}

\${color2}\${font DejaVu Sans Mono:bold:size=12}⚡ ARQUITECTURA DE HARDWARE (CPU)\${font}
\${color4}USO TOTAL:\${goto 120}\${color1}\${cpu cpu0}% \${goto 180}\${color3}\${cpubar cpu0 12,$BAR}
\${color4}NÚCLEO 1: \${color1}\${cpu cpu1}% \${color3}\${cpubar cpu1 8,150}\${goto 280}\${color4}NÚCLEO 2: \${color1}\${cpu cpu2}% \${color3}\${cpubar cpu2 8,150}
\${color4}NÚCLEO 3: \${color1}\${cpu cpu3}% \${color3}\${cpubar cpu3 8,150}\${goto 280}\${color4}NÚCLEO 4: \${color1}\${cpu cpu4}% \${color3}\${cpubar cpu4 8,150}
\${color1}\${cpugraph 50,$WIDTH 00FFFF FF00FF -t}

\${color2}\${font DejaVu Sans Mono:bold:size=12}🧠 MAPA DE MEMORIA Y SWAP\${font}
\${color4}RAM EN USO:\${goto 120}\${color1}\$mem / \$memmax \${alignr}\${color3}\${membar 12,220}
\${color4}SWAP:\${goto 120}\${color1}\$swap / \$swapmax \${alignr}\${color1}\${swapbar 8,220}
\${color1}\${memgraph 45,$WIDTH 00FFFF FF00FF}

\${color2}\${font DejaVu Sans Mono:bold:size=12}📡 ANALÍTICA DE TRÁFICO EN TIEMPO REAL\${font}
\${color4}BAJADA:\${goto 120}\${color2}\${downspeed eth0}\${downspeed wlan0}\${downspeed ens33}\${goto 280}\${color4}SUBIDA:\${goto 390}\${color3}\${upspeed eth0}\${upspeed wlan0}\${upspeed ens33}
\${color1}\${downspeedgraph eth0 50,265 00FFFF FF00FF} \${alignr}\${upspeedgraph eth0 50,265 00FFFF FF00FF}
\${color4}TOTAL BAJADA:\${goto 140}\${color1}\${totaldown eth0}\${totaldown wlan0}\${totaldown ens33}\${goto 330}\${color4}TOTAL SUBIDA:\${goto 460}\${color1}\${totalup eth0}\${totalup wlan0}\${totalup ens33}

\${color2}\${font DejaVu Sans Mono:bold:size=12}💽 INFRAESTRUCTURA DE ALMACENAMIENTO\${font}
\${color4}RAÍZ (/):\${goto 120}\${color1}\${fs_used /} / \${fs_size /}\${alignr}\${color3}\${fs_bar 12,220 /}
\${color4}HOME (/h):\${goto 120}\${color1}\${fs_used /home} / \${fs_size /home}\${alignr}\${color3}\${fs_bar 12,220 /home}
\${color1}\${diskiograph 45,$WIDTH 00FFFF FF00FF}

\${color2}\${font DejaVu Sans Mono:bold:size=12}🔥 ADMINISTRADOR DE TAREAS (TOP 5)\${font}
\${color4}PROCESO\${goto 220}PID\${goto 300}CPU%\${goto 380}MEM%\${goto 460}USER
\${color1}\${top name 1}\${goto 220}\${top pid 1}\${goto 300}\${top cpu 1}\${goto 380}\${top mem 1}\${goto 460}root
\${color4}\${top name 2}\${goto 220}\${top pid 2}\${goto 300}\${top cpu 2}\${goto 380}\${top mem 2}\${goto 460}user
\${color1}\${top name 3}\${goto 220}\${top pid 3}\${goto 300}\${top cpu 3}\${goto 380}\${top mem 3}\${goto 460}user
\${color4}\${top name 4}\${goto 220}\${top pid 4}\${goto 300}\${top cpu 4}\${goto 380}\${top mem 4}\${goto 460}user
\${color1}\${top name 5}\${goto 220}\${top pid 5}\${goto 300}\${top cpu 5}\${goto 380}\${top mem 5}\${goto 460}user

\${color1}\${hr 3}
\${alignc}\${color2}[ MONITOREO ACTIVO - JAKIMONITOR OS ]
]]
EOF

# 3. Configurar Alias para Bash y Zsh automáticamente
echo -e "${GREEN}[+] Configurando comandos rápidos (jakion / jakioff)...${NC}"

add_alias() {
    local file=$1
    if [ -f "$file" ]; then
        sed -i '/alias jakion=/d' "$file"
        sed -i '/alias jakioff=/d' "$file"
        echo "alias jakion='conky -c ~/.conkyrc > /dev/null 2>&1 &'" >> "$file"
        echo "alias jakioff='pkill -9 conky'" >> "$file"
    fi
}

add_alias ~/.bashrc
add_alias ~/.zshrc

echo -e "${CYAN}--------------------------------------------------${NC}"
echo -e "${GREEN}¡INSTALACIÓN COMPLETADA!${NC}"
echo -e "Ejecuta: ${CYAN}source ~/.zshrc${NC} (o abre una nueva terminal)"
echo -e "Comando para encender: ${CYAN}jakion${NC}"
echo -e "Comando para apagar: ${CYAN}jakioff${NC}"
echo -e "${CYAN}--------------------------------------------------${NC}"
