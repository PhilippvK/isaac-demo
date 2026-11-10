
#include "quantize.h"
#include "printing.h"
#include "exit.h"
// #include "ml_interface.h"
#include <cstring>
#include <unistd.h>
#include <stdint.h>
#include <stdbool.h>
#include  <stdio.h>

extern "C" {
int mlif_process_inputs(size_t, bool*);
int mlif_process_outputs(size_t);
void *mlif_input_ptr(int);
void *mlif_output_ptr(int);
int mlif_input_sz(int);
int mlif_output_sz(int);
int mlif_num_inputs();
int mlif_num_outputs();
}
#include <stddef.h>
const int num_data_buffers_in = 4;
const unsigned char data_buffer_in_0_0[] = {0x00, 0x00, 0x00, 0x00, };
const unsigned char data_buffer_in_1_0[] = {0xc3, 0xf5, 0xc8, 0x3f, };
const unsigned char data_buffer_in_2_0[] = {0xc3, 0xf5, 0x48, 0x40, };
const unsigned char data_buffer_in_3_0[] = {0x52, 0xb8, 0x96, 0x40, };
const unsigned char *const data_buffers_in[] = {data_buffer_in_0_0, data_buffer_in_1_0, data_buffer_in_2_0, data_buffer_in_3_0, };
const size_t data_size_in[] = {sizeof(data_buffer_in_0_0), sizeof(data_buffer_in_1_0), sizeof(data_buffer_in_2_0), sizeof(data_buffer_in_3_0), };

int mlif_process_inputs(size_t batch_idx, bool *new_)
{

    *new_ = true;
    int num_inputs = mlif_num_inputs();
    for (int i = 0; i < num_inputs; i++)
    {
        int idx = num_inputs * batch_idx + i;
        int size = mlif_input_sz(i);
        char* model_input_ptr = (char*)mlif_input_ptr(i);
        if (idx >= num_data_buffers_in)
        {
            *new_ = false;
            break;
        }
        if (size != data_size_in[idx])
        {
            return EXIT_MLIF_INVALID_SIZE;
        }
        memcpy(model_input_ptr, data_buffers_in[idx], size);
    }
    return 0;

}

int mlif_process_outputs(size_t batch_idx)
{

    for (int i = 0; i < mlif_num_outputs(); i++)
    {
        int8_t *model_output_ptr = (int8_t*)mlif_output_ptr(i);
        int size = mlif_output_sz(i);
        // TODO: move markers out of loop
        write(1, "-?-", 3);
        write(1, model_output_ptr, size);
        write(1, "-!-\n" ,4);
    }
    return 0;

}
