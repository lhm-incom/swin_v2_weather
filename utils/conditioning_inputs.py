# SPDX-FileCopyrightText: Copyright (c) 2023 NVIDIA CORPORATION & AFFILIATES. All rights reserved.
# SPDX-License-Identifier: Apache-2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import datetime

import h5py
import numpy as np
import torch
from netCDF4 import Dataset as DS


def get_orography(orography_path):
    """returns the surface geopotential for each grid point after normalizing it to be in the range [0, 1]"""

    # with DS(orography_path, "r") as f:
    #     orography = f.variables["Z"][0, :, :]
    orography = np.load(orography_path)
    # [0,1] normalize
    orography = (orography - orography.min()) / (orography.max() - orography.min())
    return orography


def get_land_mask(land_mask_path):
    """returns the land mask for each grid point. land sea mask is between 0 and 1"""

    # with h5py.File(land_mask_path, "r") as f:
    #     lsm = f["LSM"][0, :, :]

    lsm = np.load(land_mask_path)
    return lsm[0]
