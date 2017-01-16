local _M = {}

_M.config_path = '/home/openresty/config/'

--http client config
_M.http_max_conn=200--连接池最大数量
_M.http_max_expires=12*60*60*1000--12小时


return _M