FROM continuumio/miniconda3:4.7.12

RUN conda install -y \
    -c conda-forge \
    scikit-learn==0.19.1

RUN conda install --yes \
    -c conda-forge \
    python-blosc \
    bottleneck \
    cytoolz \
    dask==2.9.1 \
    distributed==2.11 \
    libgomp==9.2.0 \
    libsodium==1.0.17 \
    libtiff==4.1.0 \
    locket==0.2.0 \
    lz4 \
    nomkl \
    numba \
    numexpr \
    numpy=1.18.1 \
    pandas=0.25.3 \
    pyodbc \
    tini==0.18.0 \
    zeromq==4.3.2 \
    && conda clean -tipsy \
    && find /opt/conda/ -type f,l -name '*.a' -delete \
    && find /opt/conda/ -type f,l -name '*.pyc' -delete \
    && find /opt/conda/ -type f,l -name '*.js.map' -delete \
    && find /opt/conda/lib/python*/site-packages/bokeh/server/static -type f,l -name '*.js' -not -name '*.min.js' -delete \
    && rm -rf /opt/conda/pkgs

RUN pip install -U pip 

RUN pip install --ignore-installed git+https://github.com/mlrun/mlrun.git@development

RUN pip install adlfs~=0.1.5 \
    xlrd \
    xlwt \
    pytest \
    pyarrow \
    v3io_frames \
    cloudpickle==1.1.1 \
    msgpack==0.6.2

COPY prepare.sh /usr/bin/prepare.sh

RUN mkdir /opt/app

ENTRYPOINT ["tini", "-g", "--", "/usr/bin/prepare.sh"]
