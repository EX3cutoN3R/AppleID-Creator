#!/bin/zsh

iproxy 2222 44 &>log&rm ~/.ssh/*
if [[ "$(sshpass -p alpine ssh -o StrictHostKeyChecking=no root@localhost -p2222 'ls /var/mobile/Media/XPC')" != "/var/mobile/Media/XPC" ]]
then
	sshpass -p alpine scp -P2222 -O XPC root@localhost:/var/mobiole/Media/
	sshpass -p alpine scp -P2222 -O en.xml root@localhost:/var/mobiole/Media/
	sshpass -p alpine scp -P2222 -O Villano root@localhost:/var/mobiole/Media/
	sshpass -p alpine ssh -o StrictHostKeyChecking=no root@localhost -p2222 'cd /var/mobile/Media; ldid -Sen.xml Villano XPC; chmod +x Villano XPC'
fi
cURLSend(){
	sshpass -p alpine ssh -o StrictHostKeyChecking=no root@localhost -p2222 '/var/mobile/Media/Villano invoke AKAnisetteProvisioningController.anisetteDataWithError:' &>imdmdheaders.txt;
	IMDM="$(cat imdmdheaders.txt | grep Valor | grep -w MID | awk '{printf $7}')";
	IMD="$(cat imdmdheaders.txt | grep Valor | grep -w MID | awk '{printf $10}')";
	RINFO="$(cat imdmdheaders.txt | grep Valor | grep -w MID | awk '{printf $13}' | sed 's/}//g')";
	Clien="<$(ideviceinfo -k ProductType | awk '{printf $NF}')> <iPhone OS;$(ideviceinfo -k ProductVersion | awk '{printf $NF}');$(ideviceinfo -k BuildVersion | awk '{printf $NF}')> <com.apple.AuthKit/1 (com.apple.dt.Xcode/3594.4.19)>";
	url="$1"
	if [[ "$2" == "" ]]
	then
		curl -v -k "$url" \
		-H "Host: gsa.apple.com" \
		-H "X-Apple-Client-App-Name: Setup" \
		-H "X-Apple-I-Client-Bundle-Id: com.apple.purplebuddy" \
		-H 'X-MMe-Nas-Qualify: '$(./bicho.sh)''	\
		-H "Accept: application/x-buddyml" \
		-H "X-Mme-Device-Id: $(ideviceinfo -k UniqueDeviceID | awk '{printf $NF}')" \
		-H "X-MMe-Client-Info: $Clien" \
		-H "X-Apple-I-CDP-Circle-Status: false" \
		-H "Accept-Encoding: gzip, deflate, br" \
		-H "User-Agent: Configuraci%C3%B3n/1.0 CFNetwork/1410.1 Darwin/22.6.0" \
		-H "X-Apple-I-MD-M: $IMDM" \
		-H "X-Apple-Requested-Partition: 0" \
		-H "X-Apple-I-DeviceUserMode: 0" \
    	-H "Cookie: $(cat headers.txt| grep Set-Cookie | awk '{printf $2" "}')" \
    	-H "X-Apple-I-Client-Time: $(date -u +"%Y-%m-%dT%H:%M:%SZ")" \
		-H "X-Apple-I-MD: $IMD" \
		-H "X-Apple-I-Appearance: 2" \
		-H "X-Apple-I-Locale: es_MX" \
		-H "x-apple-i-device-type: 1" \
		-H "X-Apple-Security-Upgrade-Context: com.apple.authkit.generic" \
		-H "X-Apple-I-SRL-NO: $(ideviceinfo -k SerialNumber | awk '{printf $NF}')" \
		-H "Accept-Language: es-MX,es-419;q=0.9,es;q=0.8" \
		-H "X-Apple-I-Service-Type: icloud" \
		-H "X-Apple-I-TimeZone: GMT-7" \
		-H "X-Apple-I-TimeZone-Offset: -25200" \
		-H "X-MMe-Country: MX" \
		-H "Connection: keep-alive" \
		-H "Content-Type: application/x-plist" \
		-H "X-Apple-I-MD-RINFO: $RINFO" \
		-H "X-Apple-I-Device-Configuration-Mode: 0" \
		-H "X-Apple-iOS-SLA-Version: 0" \
		-H "X-Apple-AK-Context-Type: icloud" \
		-H "X-Apple-Offer-Security-Upgrade: 1" \
		-H "X-Apple-I-CFU-State: PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz4KPCFET0NUWVBFIHBsaXN0IFBVQkxJQyAiLS8vQXBwbGUvL0RURCBQTElTVCAxLjAvL0VOIiAiaHR0cDovL3d3dy5hcHBsZS5jb20vRFREcy9Qcm9wZXJ0eUxpc3QtMS4wLmR0ZCI+CjxwbGlzdCB2ZXJzaW9uPSIxLjAiPgo8YXJyYXkvPgo8L3BsaXN0Pgo=" \
		--compressed -D headers.txt -o gsaResponse.txt
	else
		curl -v -k "$url" \
		-H "Host: gsa.apple.com" \
		-H "X-Apple-Client-App-Name: Setup" \
		-H "X-Apple-I-Client-Bundle-Id: com.apple.purplebuddy" \
		-H 'X-MMe-Nas-Qualify: '$(./bicho.sh)''	\
		-H "Accept: application/x-buddyml" \
		-H "X-Apple-I-MLB: $(ideviceinfo -k MLBSerialNumber | awk '{printf $NF}')" \
		-H "X-Mme-Device-Id: $(ideviceinfo -k UniqueDeviceID | awk '{printf $NF}')" \
		-H "X-MMe-Client-Info: $Clien" \
		-H "X-Apple-I-CDP-Circle-Status: false" \
		-H "Accept-Encoding: gzip, deflate, br" \
		-H "User-Agent: Configuraci%C3%B3n/1.0 CFNetwork/1410.1 Darwin/22.6.0" \
		-H "X-Apple-I-MD-M: $IMDM" \
		-H "X-Apple-Requested-Partition: 0" \
		-H "X-Apple-I-DeviceUserMode: 0" \
    	-H "Cookie: $(cat headers.txt| grep Set-Cookie | awk '{printf $2" "}')" \
    	-H "X-Apple-I-Client-Time: $(date -u +"%Y-%m-%dT%H:%M:%SZ")" \
		-H "X-Apple-I-MD: $IMD" \
		-H "X-Apple-I-Appearance: 2" \
		-H "X-Apple-I-Locale: es_MX" \
		-H "x-apple-i-device-type: 1" \
		-H "X-Apple-Security-Upgrade-Context: com.apple.authkit.generic" \
		-H "X-Apple-I-SRL-NO: $(ideviceinfo -k SerialNumber | awk '{printf $NF}')" \
		-H "Accept-Language: es-MX,es-419;q=0.9,es;q=0.8" \
		-H "X-Apple-I-Service-Type: icloud" \
		-H "X-Apple-I-TimeZone: GMT-7" \
		-H "X-Apple-I-TimeZone-Offset: -25200" \
		-H "X-MMe-Country: MX" \
		-H "Connection: keep-alive" \
		-H "Content-Type: application/x-plist" \
		-H "X-Apple-I-MD-RINFO: $RINFO" \
		-H "X-Apple-I-Device-Configuration-Mode: 0" \
		-H "X-Apple-iOS-SLA-Version: 0" \
		-H "X-Apple-AK-Context-Type: icloud" \
		-H "X-Apple-Offer-Security-Upgrade: 1" \
		-H "X-Apple-I-CFU-State: PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz4KPCFET0NUWVBFIHBsaXN0IFBVQkxJQyAiLS8vQXBwbGUvL0RURCBQTElTVCAxLjAvL0VOIiAiaHR0cDovL3d3dy5hcHBsZS5jb20vRFREcy9Qcm9wZXJ0eUxpc3QtMS4wLmR0ZCI+CjxwbGlzdCB2ZXJzaW9uPSIxLjAiPgo8YXJyYXkvPgo8L3BsaXN0Pgo=" \
		-d "$(cat body)" --compressed -D headers.txt -o gsaResponse.txt
	fi
}


clear;
echo ""
countryCode=$4;dialCode=$5;
cURLSend "https://gsa.apple.com/appleid/account" ""
  
  echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<plist version=\"1.0\">
<dict>
    <key>account.person.birthday</key>
    <date>2001-12-28T00:00:00Z</date>
    <key>account.person.name.firstName</key>
    <string>$1</string>
    <key>account.person.name.lastName</key>
    <string>$2</string>
    $(./convert.sh gsaResponse.txt)
</dict>
</plist>" >body

cURLSend "https://gsa.apple.com/appleid/account/name" "yes"


  
BASE=${1:-$1}

# Número de dígitos aleatorios: 1 o 2
NUM_DIGITS=$(( RANDOM % 2 + 1 ))

# Construir el número aleatorio dígito a dígito
RAND_NUM=""
for (( i=0; i<NUM_DIGITS; i++ )); do
  RAND_NUM+=$(( RANDOM % 10 ))
done

NUM=$(( RANDOM % 1000 ))

# Imprime con 3 dígitos (rellena con ceros a la izquierda si es necesario)
NUMEROAL=$(printf "%03d\n" "$NUM");

# Imprimir el prefijo completo
  echo "${BASE}${RAND_NUM}${NUMEROAL}garcia" >prefix.txt;
  cat prefix.txt >> users
  prefix=$(cat prefix.txt)

  
  echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<plist version=\"1.0\">
<dict>
    <key>account.person.primaryEmailAddress.address</key>
    <string></string>
    <key>account.preferences.marketingPreferences.appleUpdates</key>
    <true/>
    $(./convert.sh gsaResponse.txt)
</dict>
</plist>" >body


cURLSend "https://gsa.apple.com/appleid/account/email/donthave" "yes"


echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<plist version=\"1.0\">
<dict>
    <key>account.name</key>
    <string></string>
    <key>account.nameType</key>
    <string>email</string>
    <key>account.person.primaryEmailAddress.address</key>
    <string></string>
    <key>account.person.primaryEmailAddress.addressPrefix</key>
    <string>$prefix</string>
    <key>account.person.primaryEmailAddress.addressSuffix</key>
    <string>@icloud.com</string>
    <key>account.preferences.marketingPreferences.appleUpdates</key>
    <true/>
    $(./convert.sh gsaResponse.txt)
</dict>
</plist>" >body

cURLSend 'https://gsa.apple.com/appleid/account/email' "yes"

echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<plist version=\"1.0\">
<dict>
    <key>account.nameType</key>
    <string>email</string>
    $(./convert.sh gsaResponse.txt)
</dict>
</plist>" >body

cURLSend 'https://gsa.apple.com/appleid/account/email' "yes"


echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<plist version=\"1.0\">
<dict>
    <key>account.confirmedPassword</key>
    <string>$3</string>
    <key>account.password</key>
    <string>$3</string>
    $(./convert.sh gsaResponse.txt)
</dict>
</plist>" >body

cURLSend 'https://gsa.apple.com/appleid/account/password' "yes"


PhoneNumber=$6;

echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<plist version=\"1.0\">
<dict>
	<key>account.nameType</key>
	<string>email</string>
	<key>phoneNumberVerification.mode</key>
	<string>sms</string>
	<key>phoneNumberVerification.phoneNumber.countryCode</key>
	<string>$countryCode</string>
	<key>phoneNumberVerification.phoneNumber.nonFTEU</key>
	<string>true</string>
	<key>phoneNumberVerification.phoneNumber.number</key>
	<string>$PhoneNumber</string>
    $(./convert.sh gsaResponse.txt)
</dict>
</plist>" >body
cURLSend 'https://gsa.apple.com/appleid/account/verify/phone/put' 'yes'
code="000000"
#===============================
echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<plist version=\"1.0\">
<dict>
	<key>phoneNumberVerification.securityCode.code</key>
	<string>$code</string>
    $(./convert.sh gsaResponse.txt)
</dict>
</plist>" >body
cURLSend 'https://gsa.apple.com/appleid/account/verify/phone/securitycode?verificationMode=skip' "yes"
  
echo -e "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<plist version=\"1.0\">
<dict>
    $(./convert.sh gsaResponse.txt)
</dict>
</plist>" >body

cURLSend 'https://gsa.apple.com/appleid/account' "yes"
read sicces
