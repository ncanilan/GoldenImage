# Kickstart File Template

# Network Configuration
network --bootproto=dhcp --device=eth0 --onboot=on --hostname={{ hostname }}

# Partitioning Setup
clearpart --all --initlabel

{% for partition in partitions %}
# Define partition for {{ partition.device }}
{% if partition.mount_point %}
part {{ partition.device }} --fstype ext4 --size {{ partition.size }} --mountpoint {{ partition.mount_point }}
{% else %}
part {{ partition.device }} --size {{ partition.size }}
{% endif %}
{% if partition.volume_group %}
# Create Volume Group {{ partition.volume_group.name }}
part pv.01 --size {{ partition.size }} --grow
volgroup {{ partition.volume_group.name }} pv.01

  {% for lv in partition.volume_group.logical_volumes %}
  # Logical Volume: {{ lv.name }}
  logvol {{ lv.mount_point }} --fstype {{ lv.fstype }} --size {{ lv.size }} --name {{ lv.name }} --vgname {{ partition.volume_group.name }}
  {% endfor %}
{% endif %}
{% endfor %}

# Package Selection
%packages
@core
@development-tools
%end

# Post Installation Scripts
%post
hostnamectl set-hostname {{ hostname }}
%end
