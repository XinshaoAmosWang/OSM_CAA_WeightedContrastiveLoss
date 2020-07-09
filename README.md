
# Deep Metric Learning by Online Soft Mining and Class-Aware Attention, AAAI 2019 Oral, ML Technical Track

### [[Paper]](https://arxiv.org/pdf/1811.01459.pdf) [[Slides]](https://drive.google.com/file/d/1Z44yvdrnrjIeH8x2A4e9-r275y25piKo/view?usp=sharing) [[Poster]](https://drive.google.com/file/d/1PpCpD9HLtYJQK2tGtsgIhlr1HZ3IF8zF/view?usp=sharing)

<!--
* **Good news**: Inspired by some peers' interest in our work, we are glad to release our source code for exactly reproducing our results on 4 datasets. For reproducing purpose, please do not use cudnn and change our random seed. 

* To make GoogLeNet V2 trainable on Single GPU (GeForce GTX 1080 Ti with 12 GB memory), we used very small batch size (54) in our experiments. **You may get better results if you use larger batch size and more powerful computational resources.** 
-->

### Code is under legal check now...

## Citation

If you find our code and paper make your research or work a little bit easier, it would be our great pleasure. If that is the case, please kindly cite our paper. Thanks. 

```bash
@inproceedings{wang2019deep,
  title={Deep metric learning by online soft mining and class-aware attention},
  author={Wang, Xinshao and Hua, Yang and Kodirov, Elyor and Hu, Guosheng and Robertson, Neil M},
  booktitle={Proceedings of the AAAI Conference on Artificial Intelligence},
  volume={33},
  pages={5361--5368},
  year={2019}
}
```


## Dependencies & Setup
The core functions are implemented in the [caffe](https://github.com/BVLC/caffe) framework. We use matlab interfaces matcaffe for data preparation. 

* Clone our repository:

    ```bash
    git clone git@github.com:XinshaoAmosWang/OSM_CAA_WeightedContrastiveLoss.git
    ```

* [Install dependencies on Ubuntu 16.04](http://caffe.berkeleyvision.org/install_apt.html ) 
    ```bash
    sudo apt-get install libprotobuf-dev libleveldb-dev libsnappy-dev libopencv-dev libhdf5-serial-dev protobuf-compiler
    sudo apt-get install --no-install-recommends libboost-all-dev
    sudo apt-get install libopenblas-dev
    sudo apt-get install python-dev
    sudo apt-get install libgflags-dev libgoogle-glog-dev liblmdb-dev
    ```
* Install [MATLAB 2017b](https://uk.mathworks.com/products/new_products/release2017b.html)

    Download and Run the install binary file
    ```bash
    ./install
    ```

* Compile Caffe and matlab interface
    
    * Note you may need to change some paths in Makefile.config according your system environment and MATLAB path;
    * To exactly reproduce our results, please do not use cudnn. (It is commented in the Makefile.config file.)  

    ```bash
    cd OSM_CAA_WeightedContrastiveLoss/CaffeMex_V28
    make -j8  && make matcaffe
    ```

## Usage


* Download the corresponding data files of each dataset. 

* Unzip and Copy to their corresponding training folders.
```bash
rsync -a -v Data_OSM_CAA_WeightedContrastiveLoss/*V01 .
cp Data_OSM_CAA_WeightedContrastiveLoss/googlenet_bn.caffemodel ./CARS196_V01/pretrain_model/
cp Data_OSM_CAA_WeightedContrastiveLoss/googlenet_bn.caffemodel ./CUB_V01/pretrain_model/
cp Data_OSM_CAA_WeightedContrastiveLoss/googlenet_bn.caffemodel ./MARS_V01/pretrain_model/
cp Data_OSM_CAA_WeightedContrastiveLoss/googlenet_bn.caffemodel ./LPW_V01/pretrain_model/
```

* [LPW data preparation](https://drive.google.com/drive/folders/1ryG6DCXpDeRGlRdu29C5VaRFB7cWB_ZK?usp=sharing)
* [MARS data preparation](https://drive.google.com/drive/folders/1LnbSqjxm9VBEpQg9NnPk2YMBpY5yNnFL?usp=sharing)
* [googlenet_bn.caffemodel](https://drive.google.com/file/d/1nhFtq9LcPSOkn-XolGELvjzf9Yk_gFl2/view?usp=sharing)

#### Examples for reproducing our results on CARS196, CUB-200-2011, MARS, LPW are given. 


* Data preparation for CARS196, CUB-200-2011
    
    please refer to [Ranked List Loss](https://github.com/XinshaoAmosWang/Ranked-List-Loss-for-DML#usage), the pipeline is similar.  

* Data preparation for MARS or LPW: 
    
    please refer to [Ranked List Loss](https://github.com/XinshaoAmosWang/Ranked-List-Loss-for-DML#usage), the pipeline is similar. 

* Custom data preparation

    please refer to [Ranked List Loss](https://github.com/XinshaoAmosWang/Ranked-List-Loss-for-DML#usage), the pipeline is similar. 

* Train & Test
    
    Run the training and testing scripts in the training folder of a specific setting defined by its corresponding prototxt folder. 

    Examples: 
    * CARS196: cd CARS196_V01/train_M_WIDE_ASiamese_V62_e1
        * Train: 
        ```bash
        matlab -nodisplay -nosplash -nodesktop -r "run('train.m');exit;" | tail -n +11
        ```
        * Test: 
        ```bash
        matlab -nodisplay -nosplash -nodesktop -r "run('test_model.m');exit;" | tail -n +11
        ```
    * CUB-200-2011: cd CUB_V01/train_M_WIDE_ASiamese_V42_e1
        * Train: 
        ```bash
        matlab -nodisplay -nosplash -nodesktop -r "run('train.m');exit;" | tail -n +11
        ```
        * Test: 
        ```bash
        matlab -nodisplay -nosplash -nodesktop -r "run('test_model.m');exit;" | tail -n +11
        ```





## Acknowledgements

Our work benefits from:

* Hyun Oh Song, Yu Xiang, Stefanie Jegelka and Silvio Savarese. Deep Metric Learning via Lifted Structured Feature Embedding. In IEEE Conference on Computer Vision and Pattern Recognition (CVPR), 2016. http://cvgl.stanford.edu/projects/lifted_struct/

* CaffeMex_v2 library: https://github.com/sciencefans/CaffeMex_v2/tree/9bab8d2aaa2dbc448fd7123c98d225c680b066e4

* Caffe library: https://caffe.berkeleyvision.org/

## Licence
BSD 3-Clause "New" or "Revised" License

Affiliations: 

* Queen's University Belfast, UK
* Anyvision Research Team, UK

## Contact
Xinshao Wang (You can call me Amos as well) xwang39 at qub.ac.uk


## Relevant Work
[ID-aware Quality for Set-based Person Re-identification](https://arxiv.org/pdf/1911.09143.pdf): Without weighted contrastive loss. 
```bash
@article{wang2019id,
  title={ID-aware Quality for Set-based Person Re-identification},
  author={Wang, Xinshao and Kodirov, Elyor and Hua, Yang and Robertson, Neil M},
  journal={arXiv preprint arXiv:1911.09143},
  year={2019}
}
```