require 'uri'
require 'net/http'

# http://smsbao.com/
module DuanXinBao

    SUCCESS_CODE = '0'
    ERROR_CODE = {
        '40' => '账号不存在',
        '30' => '密码错误',
        '41' => '余额不足',
        '42' => '帐号过期',
        '43' => 'IP地址限制',
        '50' => '内容含有敏感词',
        '51' => '手机号码不正确'
    }

    class << self

        def send_single_sms(phone, message, fake_send)
            params = {
                u: HtSms.config[:account],
                p: HtSms.config[:password],
                m: phone,
                c: message
            }
            if fake_send
                code = SUCCESS_CODE
            else
                code = http_post(HtSms.config[:url], params)
            end
            code == SUCCESS_CODE ? nil : ERROR_CODE[code] || "unknow error: #{code}"
        end

        def http_post(url, params)
            uri = URI.parse(URI.encode(url))
            http = Net::HTTP.new(uri.host, uri.port)
            http.use_ssl = true if uri.scheme == 'https'
            req = Net::HTTP::Post.new(uri.path)
            req.set_form_data(params)
            res = http.request(req)
            res.body
        end

    end

end
