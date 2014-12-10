# NYU Depth V2 Tools for Evaluating Superpixel Algorithms

This repository contains several tools to pre-process the ground truth segmentations as provided by the NYU Depth Dataset V2 [1]:

	[1] N. Silberman, D. Hoiem, P. Kohli, R. Fergus.
		Indoor segmentation and support inference from RGBD images.
		In Computer Vision, European Conference on, volume 7576 of Lecture Notes in Computer Science, pages 746–760. Springer Berlin Heidelberg, 2012.

The code was used to evaluate several superpixel algorithms in [2]. The corresponding benchmark can be found here: [https://github.com/davidstutz/extended-berkeley-segmentation-benchmark](https://github.com/davidstutz/extended-berkeley-segmentation-benchmark).

	[2] D. Stutz, A. Hermans, B. Leibe.
		Superpixel Segmentation using Depth Information.
		Bachelor thesis, RWTH Aachen University, Aachen, Germany, 2014.

The code was originally written by Liefeng Bo and used in [3]:

	[3] X. Ren, L. Bo.
		Discriminatively trained sparse code gradients for contour detection.
		In Advances in Neural Information Processing Systems, volume 25, pages 584–592. Curran Associates, 2012.

## Usage

Overview:

* `convert_dataset.m`: Used to split the dataset into training and test set according to `list_train.txt` and `list_test.txt`. In addition, the ground truth segmentations are converted to the format used by the Berkeley Segmentation Benchmark [4] and its extended versio (see above).
* `collect_train_subset.m`: A training subset comprising 200 images is depicted in `list_train_subset.txt` and this function is used to copy all files within this subset in separate folders.`.
* `collect_test_subset.m`: Copies all files belonging to a subset of the test set in separate folders (as above).

Detailed usage information can be found in the corresponding MatLab files.

## License

For detailed license information on the original code, contact Liefeng Bo <lifengb@gmail.com>.

The remaining part of the code is licensed as stated below.

Copyright (c) 2014, David Stutz All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
* Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
* Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.