FROM python:3

WORKDIR /usr/src/app

RUN apt-get update
RUN apt-get upgrade -y

# Anaconda installing
RUN apt-get install libgl1-mesa-glx libegl1-mesa libxrandr2 libxrandr2 libxss1 libxcursor1 libxcomposite1 libasound2 libxi6 libxtst6 -y

RUN wget https://repo.continuum.io/archive/Anaconda3-5.0.1-Linux-x86_64.sh
#RUN bash Anaconda3-5.0.1-Linux-x86_64.sh -b
#RUN rm Anaconda3-5.0.1-Linux-x86_64.sh

RUN bash Anaconda3-5.0.1-Linux-x86_64.sh -b && \
    echo "export PATH="/root/anaconda3/bin:$PATH"" >> ~/.bashrc && \
    /bin/bash -c "source ~/.bashrc"
ENV PATH /root/anaconda3/bin:$PATH
RUN conda update --all




COPY app.py . 
COPY test_deploy.py .
COPY Procfile .
COPY server.log .
RUN mkdir -p /usr/src/app/model
COPY model/model_frcnn_vgg.hdf5 .
COPY model/model_vgg_config.pickle .
RUN cp model_frcnn_vgg.hdf5 model/
RUN cp model_vgg_config.pickle model/ 
RUN mkdir -p /usr/src/app/templates
COPY templates/hello.html .
RUN cp hello.html templates/ 
RUN mkdir -p /usr/src/app/prediction
RUN mkdir -p /usr/src/app/uploads


COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt




RUN conda install tensorflow==2.0.0
RUN conda install opencv



#RUN conda install keras


CMD  ["python", "./app.py"] 






