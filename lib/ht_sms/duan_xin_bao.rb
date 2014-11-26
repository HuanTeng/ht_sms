require 'uri'
require 'net/http'

# http://smsbao.com/
module DuanXinBao

    SuccessCode = '0'
    ErrorCode = {
        '40' => '账号不存在',
        '30' => '密码错误',
        '41' => '余额不足',
        '42' => '帐号过期',
        '43' => 'IP地址限制',
        '50' => '内容含有敏感词',
        '51' => '手机号码不正确'
    }

    if defined?(Setting)
        Config = {
            account: dxb.account,
            password: dxb.password,
            url: dxb.url
        }
    else
        Config = {
            account: nil,
            password: nil,
            url: nil
        }
    end

    class << self

        def send_single_sms(phone, message, fake_send)
            params = {
                u: Config.account,
                p: Config.password,
                m: phone,
                c: message
            }
            if fake_send
                code = SuccessCode
            else
                code = http_post(Config.url, params)
            end
            code == SuccessCode ? nil : ErrorCode[code] || "unknow error: #{code}"
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
