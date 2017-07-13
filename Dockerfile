FROM leeonky/rvm

USER $USER_NAME

RUN sudo yum install -y nodejs redis && \
	sudo mkdir -p /usr/local/var/db/redis/ && \
	sudo chown $USER_NAME:$USER_NAME /usr/local/var/db/redis/ -R

COPY ./mongodb-source /etc/yum.repos.d/mongodb-org-3.4.repo

RUN sudo yum install -y \
	OpenEXR-devel \
	bzip2-devel \
	ghostscript-devel \
	jasper-devel \
	lcms2-devel \
	libjpeg-devel \
	libtiff-devel \
	libwebp-devel \
	libcroco \
	librsvg2 \
	libtool-ltdl \
	libwmf-lite \
	freetype-devel \
	libXt-devel \
	fftw3 \
	mongodb-org && \
	sudo rpm -ivh https://github.com/leeonky/tools_dev/raw/master/ImageMagick-libs-6.9.6-5.x86_64.rpm && \
	sudo rpm -ivh https://github.com/leeonky/tools_dev/raw/master/ImageMagick-6.9.6-5.x86_64.rpm && \
	sudo rpm -ivh https://github.com/leeonky/tools_dev/raw/master/ImageMagick-devel-6.9.6-5.x86_64.rpm

ADD projects /tmp/projects
ADD setup_project.sh /tmp/setup_project.sh

RUN sudo chown $USER_NAME:$USER_NAME /tmp/projects -R
RUN /bin/bash --login /tmp/setup_project.sh /tmp/projects/station-wb

CMD bash
