meta:
 id: ramses_amr
 id: gadget_format1
 id: array_buffer
 endian: le
 #file-extension: out00001
 ks-opaque-types: true
#ramses_amr, gadget, and array_buffer from astro-data-formats on github

#ramses_amr portion; ramses_amr.ksy
seq:
  - id: header
    type: ramses_header
  - id: amr_info
    type: ramses_amr_info
types:
  ramses_amr_info:
    seq:
      - id: level_infos
        type: ramses_amr_level_info(_index)
        repeat: expr
        repeat-expr: _root.header.nlevelmax.value[0].as<u4>
  ramses_amr_level_info:
    params:
      - id: level
        type: u4
    seq:
      - id: cpu_info
        type:
          switch-on: _root.header.numbl.vector[level].values[_index] 
          cases:
            0: empty_type
            _: ramses_level_cpu_info
        repeat: expr
        repeat-expr: _root.header.ncpu.value[0].as<u4> + _root.header.nboundary.value[0].as<u4>
  ramses_level_cpu_info:
    # This is where we need to check the number of grids here
    # yt has:
    # if icpu < ncpu:
    #     ng = numbl[ilevel, icpu]
    # else:
    #     ng = ngridbound[icpu - ncpu + nboundary * ilevel]
    # we should split this up and have it accept a parameter
    seq:
      - id: grid_index
        type: fortran_skip
      - id: grid_next
        type: fortran_skip
      - id: grid_prev
        type: fortran_skip
      - id: pos_x
        type: fortran_vector("f8")
      - id: pos_y
        type: fortran_vector("f8")
      - id: pos_z
        type: fortran_vector("f8")
      - id: fields
        type: fortran_skip
        repeat: expr
        repeat-expr: 31
  ramses_header:
    seq:
      - id: ncpu
        type: fortran_record(1, "u4")
      - id: ndim
        type: fortran_record(1, "u4")
      - id: nx
        type: fortran_record(3, "u4")
      - id: nlevelmax
        type: fortran_record(1, "u4")
      - id: ngridmax
        type: fortran_record(1, "u4")
      - id: nboundary
        type: fortran_record(1, "u4")
      - id: ngrid_current
        type: fortran_record(1, "u4")
      - id: boxlen
        type: fortran_record(1, "f8")
      - id: nout
        type: fortran_record(3, "u4")
      - id: tout
        type: fortran_record(nout.value[0].as<u4>, "f8")
      - id: aout
        type: fortran_record(nout.value[0].as<u4>, "f8")
      - id: t
        type: fortran_record(1, "f8")
      - id: dtold
        type: fortran_record(nlevelmax.value[0].as<u4>, "f8")
      - id: dtnew
        type: fortran_record(nlevelmax.value[0].as<u4>, "f8")
      - id: nstep
        type: fortran_record(2, "u4")
      - id: stat
        type: fortran_record(3, "f8")
      - id: cosm
        type: fortran_record(7, "f8")
      - id: timing
        type: fortran_record(5, "f8")
      - id: mass_sph
        type: fortran_record(1, "f8")
      - id: headl
        type: fortran_vector("u4")
      - id: taill
        type: fortran_vector("u4")
      - id: numbl
        # numbl is of shape [nlevelmax, ncpu+nboundary]
        #type: fortran_vector("u4")
        # This is set up so that the first is of shape nlevelmax and second is
        # ncpu+nboundary.
        # access like _root.header.numbl.vector[level].values[cpu]
        type:
          fortran_2d_vector("u4", nlevelmax.value[0].as<u4>)
      - id: unk1
        type: fortran_skip
      - id: ngridbound
        if: nboundary.value[0].as<u4> > 0
        type: fortran_vector("u4")
      - id: free_mem
        type: fortran_record(5, "u4")
      - id: ordering
        type: charstring
      - id: unk2
        type: fortran_skip
        repeat: expr
        repeat-expr: 4
  fortran_record:
    params:
      - id: num_records
        type: u4
      - id: record_type
        type: str
    seq:
      - id: rec_size1
        type: u4
      - id: value
        type:
          switch-on: record_type
          cases:
            '"u4"': u4
            '"u8"': u8
            '"f8"': f8
            '"f8"': f8
        repeat: expr
        repeat-expr: num_records
      - id: rec_size2
        type: u4
  fortran_vector:
    params:
      - id: record_type
        type: str
    seq:
      - id: rec_size1
        type: u4
      - id: vector
        type: vector_values(record_type)
        size: rec_size1
      - id: rec_size2
        type: u4
  fortran_2d_vector:
    params:
      - id: record_type
        type: str
      - id: nrows
        type: u4
    seq:
      - id: rec_size1
        type: u4
      - id: vector
        type: vector_values(record_type)
        repeat: expr
        repeat-expr: nrows
        size: rec_size1 / nrows
      - id: rec_size2
        type: u4
  vector_values:
    params:
      - id: record_type
        type: str
    seq:
      - id: values
        type:
          switch-on: record_type
          cases:
            '"u4"': u4
            '"u8"': u8
            '"f8"': f8
            '"f8"': f8
        repeat: eos
  fortran_skip:
    seq:
      - id: rec_size1
        type: u4
      - id: contents
        size: rec_size1
      - id: rec_size2
        type: u4
  charstring:
    seq:
      - id: rec_size1
        type: u4
      - id: contents
        type: str
        size: rec_size1
        encoding: ascii
      - id: rec_size2
        type: u4
  empty_type:
    seq: []
#array buffer portion; array_buffer.ksy
params:
  - id: field_type
    type: str
seq:
  - id: buffer
    size-eos: true
instances:
  values:
    pos: 0
    size-eos: true
    id: entries
    type:
      switch-on: field_type
      cases:
        '"f8"': f8
        '"u4"': u4
        '"f8"': f8
        '"u8"': u8
        _ : f8
    repeat: eos

#gadget; gadget.ksy
seq:
  - id: gadget_header
    type: header
  - id: coordinates
    type: particle_fields('f4', 3, _root.field_counts.all_fields)
  - id: velocities
    type: particle_fields('f4', 3, _root.field_counts.all_fields)
  - id: particle_ids
    type: particle_fields('u4', 1, _root.field_counts.all_fields)
  - id: mass
    type: particle_fields('f4', 1, _root.field_counts.has_mass)
instances:
  field_counts:
    pos: 0
    size: 1
    type: has_fields
types:
  header:
    seq:
      - id: recsize_0
        type: u4
      - id: npart
        type: u4
        repeat: expr
        repeat-expr: 6
      - id: massarr
        type: f8
        repeat: expr
        repeat-expr: 6
      - id: time
        type: f8
      - id: redshift
        type: f8
      - id: flag_sfr
        type: u4
      - id: flag_feedback
        type: u4
      - id: n_all
        type: u4
        repeat: expr
        repeat-expr: 6
      - id: flag_cooling
        type: u4
      - id: numfiles
        type: u4
      - id: boxsize
        type: f8
      - id: omega0
        type: f8
      - id: omega_lambda
        type: f8
      - id: hubble_param
        type: f8
      - id: flag_age
        type: u4
      - id: flag_metals
        type: u4
      - id: nall_hw
        type: u4
        repeat: expr
        repeat-expr: 6
      - id: unused
        type: u4
        repeat: expr
        repeat-expr: 16
      - id: recsize_1
        type: u4
  particle_fields:
    params:
      - id: field_type
        type: str
      - id: components
        type: u4
      - id: has_field
        type: bool_value[]
    seq:
      - id: magic1
        type: u4
      - id: fields
        type: field(_index, components, field_type, has_field[_index].value)
        repeat: expr
        repeat-expr: 6
      - id: magic2
        type: u4
  field:
    params:
      - id: index
        type: u4
      - id: components
        type: u4
      - id: field_type
        type: str
      - id: has_field
        type: bool
    seq:
      - id: field
        if: has_field
        size: _root.gadget_header.npart[index] * components * 4
        type: array_buffer(field_type)
  bool_value:
    params:
      - id: this_value
        type: bool
    instances:
      value:
        value: this_value
  has_fields:
    seq:
      - id: all_fields
        repeat: expr
        repeat-expr: 6
        type: bool_value(true)
      - id: has_mass
        repeat: expr
        repeat-expr: 6
        type: bool_value(_root.gadget_header.massarr[_index] == 0)
      - id: has_gas
        repeat: expr
        repeat-expr: 6
        type: bool_value(_index == 2)
