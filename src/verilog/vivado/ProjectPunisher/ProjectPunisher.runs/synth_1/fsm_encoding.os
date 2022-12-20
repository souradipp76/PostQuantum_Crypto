
 add_fsm_encoding \
       {angle_combination.state_angle_combination} \
       { }  \
       {{0000 0000} {0001 0001} {0010 0010} {0011 0011} {0100 0100} {0101 0101} {0110 0110} {0111 0111} {1000 1000} }

 add_fsm_encoding \
       {angle_normalization.state_angle_normalization} \
       { }  \
       {{0000 000} {0001 010} {0010 011} {0011 100} {0100 101} {0101 001} {1000 110} }

 add_fsm_encoding \
       {decoder_type_3.state_decoder} \
       { }  \
       {{0000 001} {0001 010} {0010 100} }

 add_fsm_encoding \
       {term_accumulator.state_term_accumulator} \
       { }  \
       {{0000 00000001} {0001 00000010} {0010 00000100} {0011 00001000} {0100 01000000} {0101 00010000} {0110 10000000} {0111 00100000} }

 add_fsm_encoding \
       {exp_evaluator.state_exp_eval} \
       { }  \
       {{0000 000000001} {0001 000000100} {0010 000001000} {0011 000010000} {0100 000100000} {0101 001000000} {0110 010000000} {0111 000000010} {1000 100000000} }

 add_fsm_encoding \
       {mult_add.state_mult_add} \
       { }  \
       {{0000 00} {0001 01} {0010 10} {0011 11} }

 add_fsm_encoding \
       {float_point_adder.state} \
       { }  \
       {{0000 000} {0001 001} {0010 010} {0011 011} {0100 100} {0101 101} {0110 110} }

 add_fsm_encoding \
       {exponent_operation.state_exponent_operation} \
       { }  \
       {{0000 00001} {0001 00010} {0010 01000} {0011 10000} {0101 00100} }
