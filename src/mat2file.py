import scipy.io as sio
import numpy as np
import argparse

def mat2file(filearray, dest):
  mfile = []
  for i in range(0, len(filearray)):
    key=filearray[i][-5]
    mat = np.ndarray.tolist(sio.loadmat(filearray[i])[key])[0]
    mfile.append(mat)

  with open(dest, "w+") as f:
    for j in range(0, len(mfile)):
      for i in range(0, len(mfile[j])):
	f.write(str(mfile[j][i])+" ")
      f.write("\n")
  f.close()

if __name__ == "__main__":
   parser = argparse.ArgumentParser(description='Save value in .mat file as txt file')
   parser.add_argument('-p', dest='path', type=str,
                        help='Path used to store the output txt file')
   parser.add_argument('-s', dest='source', nargs="+",
                        help='Paths in a array used to read the mat file')

   args = parser.parse_args()
   source = args.source
   path = args.path
   # exxample usage
   # python mat2file.py -s "../data/VIPx.mat" "../data/VIPb.mat" -p "../data/filter.txt"

   mat2file(source, path)
