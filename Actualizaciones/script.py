strigsServers = """EMVTS03.emv.com.ar
BRTERP01.brt.com.ar
MTVBL115.metrovias.com.ar
MTVDMZSUBE03.metrovias.com.ar
MTVGT03.metrovias.com.ar
MTVGT04.metrovias.com.ar
MTVIIS100.metrovias.com.ar
MTVMONReca.metrovias.com.ar
MTVRPT02.metrovias.com.ar
MTVSAT02.metrovias.com.ar
MTVSHAREPOINT02.Metrovias.com.ar
MTVTS03.metrovias.com.ar
MTVTS101.metrovias.com.ar
MTVUDP02.metrovias.com.ar
MTVWEB03.metrovias.com.ar
MTVWEBWP03.metrovias.com.ar
MTVWSBRINKS01.metrovias.com.ar"""

listaServers =strigsServers.split()

for server in listaServers:
    finalString = ""
    serverString = f"mstsc /admin /v:{server}"
    print(serverString)




