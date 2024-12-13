import numpy as np
import torch
from torchinfo import summary

from networks.helpers import get_model
from utils.YParams import YParams

params = YParams("./config/vit.yaml", "vit_short")
params["in_channels"] = np.array(params["in_channels"])
params["out_channels"] = np.array(params["out_channels"])
params["n_in_channels"] = len(params["in_channels"])
params["n_out_channels"] = len(params["out_channels"])
model = get_model(params)
summary(model, input_size=(1, 73, 720, 1440))
