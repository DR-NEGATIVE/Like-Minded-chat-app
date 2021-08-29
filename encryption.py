import pandas as pd

encryptionkey = pd.read_csv(r"<YourPathTo.csv>",
                            sep=',', names=['Character', 'Byte'], header=None, skiprows=[0])

df = pd.DataFrame(data=encryptionkey)

df['Character'] = df['Character'].astype(str)
df['Byte'] = df['Byte'].astype(str)

def split(message):
    return [char for char in message]

message = 'It is a beautiful day to code something new. In fact, a day like any other,' \
          ' with new projects and ideas. Maybe also new challenges and nerve-rackings bugs. Time will tell.'

message_split = split(message)

print(message_split)

def code_message():
    coded_message = ""

    for i in range(len(message_split)):
        j = message_split[i]
        try:
            coded_char = encryptionkey.loc[encryptionkey['Character'] == j, 'Byte'].iloc[0]
            print(type(coded_char))

        # To handle if character is not in our decryption list
        except:
            print('unrecognized character')
            coded_char = '@@@'

        coded_message = coded_message + coded_char
    return coded_message

coded_message = code_message()

print('Your coded message:', code_message(), '\n')

def decode_message(message):
    new_word = ''
    decoded_message = []

    for i in range(0, len(message), 2):
        j = message[i:i + 2]
        index_nb = df[df.eq(j).any(1)]

        df2 = index_nb['Character'].tolist()

        s = [str(x) for x in df2]

        decoded_message = decoded_message + s

    new_word = ''.join(decoded_message)

    return new_word

coded_message_str = str(coded_message)
print('Your decoded message:', decode_message(coded_message_str))
