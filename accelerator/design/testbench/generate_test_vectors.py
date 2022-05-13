from random import random
import math
import numpy as np
import binascii
import struct

num_vectors = 10

def get_hex(x):
  return str(binascii.hexlify(struct.pack('>i', x.view(np.int32))))[2:10]


def quat_mult_gold(quat0, quat1):
  w0, x0, y0, z0 = quat0
  w1, x1, y1, z1 = quat1
  return np.array([-x1 * x0 - y1 * y0 - z1 * z0 + w1 * w0,
                    x1 * w0 + y1 * z0 - z1 * y0 + w1 * x0,
                   -x1 * z0 + y1 * w0 + z1 * x0 + w1 * y0,
                    x1 * y0 - y1 * x0 + z1 * w0 + w1 * z0], dtype=np.float32)


def mac_tb():
  f = open("test_vectors.txt", "w")
  acc = 0
  for i in range(num_vectors):
    a = np.float32(random() * 10)
    b = np.float32(random() * 10)
    acc = np.float32(acc + a * b)
    f.write(str(get_hex(acc)) + '_' + str(get_hex(b)) + '_' + str(get_hex(a)) + '\n')
    i = i + 1
  f.close()


def matrix_multiply_accumulate_tb():
  f = open("test_vectors.txt", "w")
  for _ in range(num_vectors):
    a = np.random.rand(3, 3).astype(np.float32)
    b = np.random.rand(3, 3).astype(np.float32)
    product = a @ b
    data = np.concatenate((a, b, product)).flatten()
    for num in data:
      f.write(get_hex(num) + '\n')
  f.close()


def quat_mult_tb():
  f = open("test_vectors.txt", "w")
  a = np.random.rand(4).astype(np.float32)
  b = np.random.rand(4).astype(np.float32)
  product = quat_mult_gold(a, b)
  data = np.concatenate((a, b, product)).flatten()
  for num in data:
    f.write(get_hex(num) + '\n')
  f.close()


def esekf_tb():
  f = open("test_vectors.txt", "w")
  a = np.random.rand(3, 3).astype(np.float32)
  b = np.random.rand(3, 3).astype(np.float32)
  c = np.random.rand(3, 3).astype(np.float32)
  product = a @ b
  sum = a + c

  str_a = '_'.join(map(get_hex, a.flatten('F'))) 
  str_b = '_'.join(map(get_hex, b.flatten('F'))) 
  str_c = '_'.join(map(get_hex, c.flatten('F'))) 
  str_prod = '_'.join(map(get_hex, product.flatten('F')))
  f.write(str_a + '\n')
  f.write(str_b + '\n')
  f.write(str_c + '\n')
  f.write(str_prod + '\n')
  f.close()

if __name__ == "__main__":
  esekf_tb()
