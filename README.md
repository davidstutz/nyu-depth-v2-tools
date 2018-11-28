# NYU Depth V2 Tools for Evaluating Superpixel Algorithms

This repository contains several tools to pre-process the ground truth segmentations as provided by the NYU Depth Dataset V2 [1]:

	[1] N. Silberman, D. Hoiem, P. Kohli, R. Fergus.
		Indoor segmentation and support inference from RGBD images.
		In Computer Vision, European Conference on, volume 7576 of Lecture Notes in Computer Science, pages 746–760. Springer Berlin Heidelberg, 2012.

The code was used to evaluate several superpixel algorithms in [2] and [3]. The corresponding benchmark can be found here: [https://github.com/davidstutz/extended-berkeley-segmentation-benchmark](https://github.com/davidstutz/extended-berkeley-segmentation-benchmark).

	[2] D. Stutz.
		Superpixel Segmentation using Depth Information.
		Bachelor thesis, RWTH Aachen University, Aachen, Germany, 2014.
	[3] D. Stutz.
		Superpixel Segmentation: An Evaluation.
		Pattern Recognition (J. Gall, P. Gehler, B. Leibe (Eds.)), Lecture Notes in Computer Science, vol. 9358, pages 555 - 562, 2015.

The code was originally written by Liefeng Bo and used in [4]:

	[4] X. Ren, L. Bo.
		Discriminatively trained sparse code gradients for contour detection.
		In Advances in Neural Information Processing Systems, volume 25, pages 584–592. Curran Associates, 2012.

## Usage

Overview:

* `convert_dataset.m`: Used to split the dataset into training and test set according to `list_train.txt` and `list_test.txt`. In addition, the ground truth segmentations are converted to the format used by the Berkeley Segmentation Benchmark [4] and its extended versio (see above).
* `collect_train_subset.m`: A training subset comprising 200 images is depicted in `list_train_subset.txt` and this function is used to copy all files within this subset in separate folders.`.
* `collect_test_subset.m`: Copies all files belonging to a subset of the test set in separate folders (as above).

Detailed usage information can be found in the corresponding MatLab files.

## License

Licenses for source code corresponding to:

D. Stutz. **Superpixel Segmentation using Depth Information.** Bachelor Thesis, RWTH Aachen University, 2014.

D. Stutz. **Superpixel Segmentation: An Evaluation.** Pattern Recognition (J. Gall, P. Gehler, B. Leibe (Eds.)), Lecture Notes in Computer Science, vol. 9358, pages 555 - 562, 2015.

Note that the source code and/or data is based on the following projects for which separate licenses apply:

* code by Liefeng Bo <lifengb@gmail.com>

Copyright (c) 2014-2018 David Stutz, RWTH Aachen University

**Please read carefully the following terms and conditions and any accompanying documentation before you download and/or use this software and associated documentation files (the "Software").**

The authors hereby grant you a non-exclusive, non-transferable, free of charge right to copy, modify, merge, publish, distribute, and sublicense the Software for the sole purpose of performing non-commercial scientific research, non-commercial education, or non-commercial artistic projects.

Any other use, in particular any use for commercial purposes, is prohibited. This includes, without limitation, incorporation in a commercial product, use in a commercial service, or production of other artefacts for commercial purposes.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

You understand and agree that the authors are under no obligation to provide either maintenance services, update services, notices of latent defects, or corrections of defects with regard to the Software. The authors nevertheless reserve the right to update, modify, or discontinue the Software at any time.

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software. You agree to cite the corresponding papers (see above) in documents and papers that report on research using the Software.
