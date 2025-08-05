meta:
 id: phantom_sph
 endian: be
 ks-opaque-types: false
seq:
  - id: opening_gambit
    type: phantom_magic
  - id: filename
    type: phantom_filename
  - id: header
    type: global_header
  - id: block_info
    type: block_header
types:
  phantom_magic:
    seq:
      # Ultimately, with this header we know the size of the default real/int.
      - id: fortran_header
        type: u4
      - id: header_i1
        contents: [0x00, 0x00, 0xed, 0x61]
      - id: header_r1
        type: f8
      - id: header_i2
        contents: [0x00, 0x00, 0xed, 0xce]
      - id: iversion
        type: u4
      - id: header_i3
        contents: [0x00, 0x0a, 0x8a, 0x12]
      - id: fortran_footer
        type: u4
  phantom_filename:
    seq:
      - id: fortran_header
        type: u4
      - id: value
        type: str
        encoding: ascii
        size: 100
      - id: fortran_footer
        type: u4
  global_header:
    seq:
      - id: type_info
        type: datatype_header
        repeat: expr
        repeat-expr: 8
  datatype_header:
    seq:
      - id: nvars_fortran_header
        type: u4
      - id: nvars
        type: u4
      - id: nvars_fortran_footer
        type: u4
      - id: varinfo
        if: nvars > 0
        type: datatype_varinfo
  datatype_varinfo:
    seq:
      - id: tags_fortran_header
        type: u4
      - id: tags
        type: str
        size: 16
        encoding: ascii
        repeat: expr
        repeat-expr: _parent.nvars
      - id: tags_fortran_footer
        type: u4
      - id: vals_fortran_header
        type: u4
      - id: vals
        size: vals_fortran_header
      - id: vals_fortran_footer
        type: u4
  block_def:
    seq:
      - id: block_def_header
        type: u4
      - id: n
        type: u8
      - id: nums
        type: u4
        repeat: expr
        repeat-expr: 8
      - id: block_def_footer
        type: u4
  block_header:
    seq:
      - id: nblocks_fortran_header
        type: u4
      - id: nblocks
        type:
          switch-on: nblocks_fortran_header
          cases:
            4: u4
            8: u8
      - id: nblocks_fortran_footer
        type: u4
      - id: blocks
        type: block_def
        repeat: expr
        repeat-expr: nblocks
      - id: arrays
        type: block_arrays(_index)
        repeat: expr
        repeat-expr: nblocks
  block_arrays:
    params:
      - id: block_id
        type: u4
    seq:
      - id: array
        type: block_array_per_type(_parent.blocks[block_id].nums[_index])
        repeat: expr
        repeat-expr: 8
  block_array_per_type:
    params:
      - id: num
        type: u4
    seq:
      - id: block_array
        type: block_array_item
        repeat: expr
        repeat-expr: num
  block_array_item:
    seq:
      - id: tag_header
        type: u4
      - id: tag
        type: str
        size: 16
        encoding: ascii
      - id: tag_footer
        type: u4
      - id: array_header
        type: u4
      - id: array
        size: array_header
      - id: array_footer
        type: u4
