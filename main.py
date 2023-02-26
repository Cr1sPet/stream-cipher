state = 0b1000
m = 
first_digit = (state >> 3) & 1
last_digit = state & 1
result = first_digit ^ last_digit
print("{:04b}".format(result))
state = (state >> 1) | (result << 3)
print("{:04b}".format(state))
#     # print("{:04b}".format(state))


# for i in range(20):
#     # print("{:04b}".format(state))
#     # newbit = (state ^ (state >> 1)) & 1
#     # state = (state >> 1) | (newbit << 3)
