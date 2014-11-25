require 'uri'
require 'net/http'

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

    # http://smsbao.com/
    def self.send_single_sms(phone, message)
        dxb = Setting.duan_xin_bao
        params = {
            u: dxb.account,
            p: dxb.password,
            m: phone,
            c: message
        }
        code = http_post(dxb.url, params)

        SuccessCode ? nil : ErrorCode[code] || "unknow error: #{code}"
    end

    private

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
