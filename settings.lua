data:extend{
    {
        name = 'wyrm-quality',
        setting_type = 'startup',
        type = 'bool-setting',
        order = 'a',
        default_value = true,
    },
    {
        name = 'wyrm-spawner-density',
        setting_type = 'startup',
        type = 'double-setting',
        order = 'a',
		minimum_value = 0.1,
		maximum_value = 10,
        default_value = 1.0,
    },
}