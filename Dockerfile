FROM <<BASECONTAINER>>

MAINTAINER docker@intrepid.de
# based on https://github.com/WalterS/docker-squeezeboxserver
# with updates from: 
#   https://github.com/twobaker/squeezeboxserver
#   https://github.com/McSlow/docker-squeezeboxserver

ENV VERSION=<<LMSVERSION>>

RUN passwd -l root ; \
#   yum -y update --security && \
    yum -y update && \
    yum -y install perl-Time-HiRes perl-CGI perl-YAML perl-Digest-MD5 initscripts perl-IO-Socket-SSL.noarch && \
	sed -i 's/pidof -c -m/pidof -m/g' /etc/init.d/functions && \
	echo 'squeezeboxserver:x:8888' >> /etc/group && \
	echo 'squeezeboxserver:x:8888:8888:Logitech Media Server:/usr/share/squeezeboxserver/squeezeboxserver:/bin/bash' >> /etc/passwd && \
	yum -y install http://downloads.slimdevices.com/LogitechMediaServer_${LMSVERSION}/logitechmediaserver-${LMSVERSION}-1.noarch.rpm && \
	ln -s /usr/lib/perl5/vendor_perl/Slim /usr/lib64/perl5/ && \
	yum clean all && \
	rm -rf /var/lib/yum/yumdb /var/tmp/* /tmp/*; \
	for i in $(find /var/log -type f); do echo > $i;done; \
	rm /root/{*cfg,*log*}

COPY ./bin/run_server /usr/local/bin/
COPY ./etc/squeezeboxserver /etc/sysconfig/

VOLUME ['/mnt/state']
EXPOSE 3483 9000 9090

CMD /usr/local/bin/run_server
