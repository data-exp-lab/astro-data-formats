meta:
  id: array_buffer
  endian: le
seq:
  - id: buffer
    size-eos: true
instances:
  values_f4:
    pos: 0
    type: array_buffer("f4")
  values_u4:
    pos: 0
    type: array_buffer("u4")
  values_f8:
    pos: 0
    type: array_buffer("f8")
  values_u8:
    pos: 0
    type: array_buffer("u8")
types: 
  array_buffer:
    params:
      - id: field_type
        type: str
    seq:
      - id: entries
        type:
          switch-on: field_type
          cases:
            '"f4"': f4
            '"u4"': u4
            '"f8"': f8
            '"u8"': u8
            _ : f4
        repeat: eos
