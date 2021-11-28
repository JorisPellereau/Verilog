# Python
# File optimisation script
import sys



def file_optimisation(file_in, file_out):

    input_file_length = 0
    lines = []
    f = open(file_in, "r") # Open in read only
    lines = f.readlines() # Get All lines in files
    f.close() # Close File

    # Prin input info
    input_file_length = len(lines)

    print("Input File length - %s : %d" %(file_in, input_file_length))
    
    for line_i in range(0, len(lines)):
        lines[line_i] = lines[line_i].strip() #Remove \n


    # List with unique value and the moment a they appears
    lines_opti       = [] # Unique Lines
    lines_opti_index = [] # Line Number of the Unique line

    lines_opti.append(lines[0]) # Init with 1st value of list list
    lines_opti_index.append(0)  # Init with 1st line
    # Loop for each Lines
    for line_i in range(0, len(lines)):

        if(lines[line_i] not in lines_opti):
            lines_opti.append(lines[line_i]) # Add to line in order of appareance
            lines_opti_index.append(line_i)   # Add index                              

    data_out = []
    for line in range(0, len(lines_opti)):
        data_out.append("{0} {1}".format(lines_opti[line], lines_opti_index[line])) # Create output List to write in file

    data_out_to_file = "\n".join(data_out)
    
    f = open(file_out, "w")
    f.write(data_out_to_file)
    f.close()

    # Print Info
    print("Output File - %s : %d" %(file_out, len(data_out_to_file)))
    print("file_optimsation Done.")

print(sys.argv[1])
file_optimisation(sys.argv[1], sys.argv[2])
