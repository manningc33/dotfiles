return {
  'windwp/nvim-autopairs',
  event = 'InsertEnter',
  opts = {
    check_ts = true,
    ts_config = {
      lua = { 'string' },
    },
    fast_wrap = {
      keys = 'arstneiowfpluycdvh',
    },
  },
}
