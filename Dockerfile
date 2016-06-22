FROM tsutomu7/ubuntu-essential

ENV USER=scientist HOME=/home/scientist \
    PATH=/opt/conda/bin:$PATH \
    LANG=C.UTF-8 \
    DEBIAN_FRONTEND=noninteractive \
    MINICONDA=Miniconda3-latest-Linux-x86_64.sh
COPY notebook.json $HOME/.jupyter/nbconfig/
RUN export uid=1000 gid=1000 pswd=scientist && \
    apt-get update --fix-missing && apt-get install -y --no-install-recommends sudo \
        libglib2.0-0 libxext6 libsm6 libxrender1 tzdata busybox wget fonts-ipaexfont && \
    groupadd -g $gid $USER && \
    useradd -g $USER -G sudo -m -s /bin/bash $USER && \
    echo "$USER:$pswd" | chpasswd && \
    mkdir -p $HOME/.local/share/jupyter && \
    mkdir -p /etc/sudoers.d && \
    echo "$USER ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$USER && \
    chmod 0440 /etc/sudoers.d/$USER && \
    /bin/busybox --install && \
    cp --remove-destination /usr/share/zoneinfo/Japan /etc/localtime && \
    apt-get --purge autoremove -y tzdata && \
    apt-get clean && \
    echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
    wget -q --no-check-certificate \
            https://repo.continuum.io/miniconda/$MINICONDA && \
    bash /$MINICONDA -b -p /opt/conda && \
    conda update -y conda pip setuptools && \
    conda install -y nomkl pandas matplotlib networkx scikit-learn jupyter blist numexpr \
                     bokeh blaze statsmodels ncurses seaborn dask flask markdown sympy psutil && \
    conda update -y requests && \
    pip install -U pip pyparsing && \
    pip install pulp pyjade more-itertools && \
    pip install https://github.com/ipython-contrib/IPython-notebook-extensions/archive/master.zip && \
    sed -i '6,9d' $HOME/.jupyter/jupyter_nbconvert_config.json && \
    ln -s /usr/share/fonts/opentype/ipaexfont-gothic/ipaexg.ttf \
        /opt/conda/lib/python3.5/site-packages/matplotlib/mpl-data/fonts/ttf/ && \
    find /opt -name __pycache__ | xargs rm -r && \
    chown ${uid}:${gid} -R $HOME /opt/conda && \
    rm -rf /var/lib/apt/lists/* /$MINICONDA /root/.c* /opt/conda/pkgs/* \
           /opt/conda/lib/python3.5/site-packages/pulp/solverdir/cbc/[ow]* \
           /opt/conda/lib/python3.5/site-packages/pulp/solverdir/cbc/linux/32
USER $USER
WORKDIR $HOME
CMD ["/bin/bash"]
