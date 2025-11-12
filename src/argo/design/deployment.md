

## pod setting

image: 
container name: 必填，小写 - 数字，开始和结尾必须为小写字母和数字，最大长度63
container type： worker container
cpu core：  cpu limit
mmeory（Mi）： memory limit 
gpu type： nvidia.com/gpu, gpu limit 
port settings： set the ports used for accessing the container
    protocol: http
    name:
    container Port