FROM tsutomu7/ubuntu-essential

ENV PATH=/opt/conda/bin:$PATH \
    LANG=C.UTF-8 \
    DEBIAN_FRONTEND=noninteractive \
    MINICONDA=Miniconda3-latest-Linux-x86_64.sh
COPY notebook.json /root/.jupyter/nbconfig/
RUN apt-get update --fix-missing && apt-get install -y --no-install-recommends \
        libglib2.0-0 libxext6 libsm6 libxrender1 busybox wget fonts-ipaexfont && \
    /bin/busybox --install && \
    apt-get clean && \
    echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
    wget -q --no-check-certificate \
            https://repo.continuum.io/miniconda/$MINICONDA \
            https://github.com/ipython-contrib/IPython-notebook-extensions/archive/master.zip && \
    bash /$MINICONDA -b -p /opt/conda && \
    conda update -y conda && \
    conda install -y pandas==0.17.1 matplotlib networkx scikit-learn jupyter blist bokeh blaze \
                  statsmodels ncurses seaborn dask flask markdown sympy && \
    pip install pulp pyjade more-itertools && \
    ln -s /usr/share/fonts/opentype/ipaexfont-gothic/ipaexg.ttf \
        /opt/conda/lib/python3.5/site-packages/matplotlib/mpl-data/fonts/ttf/ && \
    mkdir -p /root/.local/share/jupyter && \
    unzip -q master.zip && \
    cd IPython-notebook-extensions-master && \
    python setup.py install && \
    find /opt -name __pycache__ | xargs rm -r && \
    rm -rf /var/lib/apt/lists/* /$MINICONDA /IPython-notebook-extensions-master \
           /master.zip /root/.c* /opt/conda/pkgs/* \
           /opt/conda/lib/python3.5/site-packages/pulp/solverdir/cbc/[ow]*
CMD ["/bin/bash"]
