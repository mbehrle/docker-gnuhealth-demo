FROM postgres:9.5

# Use our local cache
#RUN echo 'Acquire::http { Proxy "http://apt-cacher:9999"; };' >> /etc/apt/apt.conf.d/01proxy

ENV DUMPFILE="gnuhealth-3.0.1-demo-data.tar.gz"
ENV SQLFILE="health301.sql"

#VOLUME /var/lib/postgresql
RUN apt-get update && apt-get install -y --no-install-recommends \
	gzip curl ca-certificates \
	&& rm -rf /var/lib/apt/lists/* \
	&& curl -o /$DUMPFILE -SL "http://health.gnu.org/downloads/postgres_dumps/$DUMPFILE" \
	&& tar --extract --file=$DUMPFILE $SQLFILE \
	&& gzip -c $SQLFILE > demo.sql.gz \
	&& rm $DUMPFILE \
	&& apt-get purge -y --auto-remove curl ca-certificates

COPY gnuhealth.sh /docker-entrypoint-initdb.d/
