rm -R source
rm -R system

case $1 in
	a3)
		ln -sf ${HOME}/blackbox/a3/source source
		ln -sf ${HOME}/blackbox/a3/system2 system;;
	s3)
		ln -sf ${HOME}/blackbox/s3/source source
		ln -sf ${HOME}/blackbox/s3/system system;;
	v3)
		ln -sf ${HOME}/blackbox/v3/source source
		ln -sf ${HOME}/blackbox/v3/system system;;
	v4)
		ln -sf ${HOME}/blackbox/v4/source source
		ln -sf ${HOME}/blackbox/v4/system system;;
	v8)
		ln -sf ${HOME}/blackbox/v8/source source
		ln -sf ${HOME}/blackbox/v8/system system;;
	*)
		ln -sf ${HOME}/blackbox/janus_a1/source source
		ln -sf ${HOME}/blackbox/janus_a1/system system;;
esac
