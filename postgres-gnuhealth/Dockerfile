FROM postgres:9.4

# Use our local cache
#RUN echo 'Acquire::http { Proxy "http://apt-cacher:9999"; };' >> /etc/apt/apt.conf.d/01proxy

#VOLUME /var/lib/postgresql
RUN apt-get update && apt-get install -y --no-install-recommends \
	gzip curl ca-certificates \
	&& rm -rf /var/lib/apt/lists/* \
	&& curl -o /demo.sql.gz -SL "http://health.gnu.org/downloads/postgres_dumps/gnuhealth-2.8.1-demo.sql.gz" \
	&& apt-get purge -y --auto-remove curl ca-certificates

COPY gnuhealth.sh /docker-entrypoint-initdb.d/
