begin
    loop{
    puts "请输入需要找寻规律的数字，用空格分开，'exit'退出"
    a=gets.chomp
    if a=="exit"
        break
    elsif not a =~ /[( \-) 0-9]/
        puts "输入非法！"
        next
    end
    a=a.split().map(&:to_i)
    op_2={
    "$+$"=>100,
    "$*$"=>40,
    "$**$"=>1,
    "$%$"=>5
    }
    op_1={
    "-$"=>100,
    "(..$).each.inject(*)"=>1,
    "1.0/$"=>10
    }
    # p op_2
    num={
    "arrayindex"=>100,
    "a[arrayindex>0?arrayindex-1:'']"=>70,
    "a[arrayindex>1?arrayindex-2:'']"=>20,
    "1"=>40,
    "2"=>10,
    "3"=>3,
    "4"=>2,
    "5"=>3.5,
    "6"=>1,
    "7"=>0.5,
    "8"=>0.8,
    "9"=>0.3,
    "10"=>4
    }
    words={
    "(arrayindex+1)"=>100,
    "*1"=>0
    }
    sum=op_2.each_value.inject(&:+)+op_1.each_value.inject(&:+)+op_2.each_value.inject(&:+)
    op_2.each_key { |key|op_2[key]/=sum.to_f  }
    op_1.each_key { |key|op_1[key]/=sum.to_f  }
    num.each_key { |key|num[key]/=sum.to_f  }
    words.each_key { |key|words[key]/=sum.to_f  }
    ans=num.to_a.sort_by { |e|-e[1]}
    if a.length<3
        puts "输入数字数量应该不少于3个"
        next
    end
    $l=a.length==3 ? 1 : a.length-3
    puts "计算中..."
    loop { 
        $t=0
        sentence,$property=ans.max_by{|e|e[1]}
        ans.delete([sentence,$property])
        # puts sentence
        # puts "执行语句："+sentence
        a.length.times { |arrayindex|
            begin
                unless eval(sentence)==a[arrayindex]
                    # puts "#{eval(sentence)}==#{ a[arrayindex] }不对,退出，$t=#{$t}"
                    $t=0
                    break
                else
                    # puts "arrayindex=#{arrayindex}正确为#{ a[arrayindex] }，$t+=1,为#{$t}"
                    $t+=1
                end
            rescue Exception => e
                # puts "出错了，看作是对的"
                # $t+=1
            end
        }
        # puts "#{$t}"
        if $t>$l
            # puts "t>0,正确"
            # puts "规则为：#{sentence},之后的数依次是："
            puts "找到规律！之后的数应该依次是："
            5.times{arrayindex=a.length
                a[arrayindex]=eval(sentence)
                print a[arrayindex]," "
            }
            break
        else
            op_1.each{|key,value|
                # puts "#{ans}<<[#{key}.sub('$',#{sentence}),#{value}*#{$property}]"
                ans<<[b=key.sub('$',sentence),words.include?(b) ? words[b] : value*$property]
            }
            op_2.each{|key,value|
                num.each{|key2,value2|
                    ans<<[b=key.sub('$',sentence).sub('$',key2),words.include?(b) ? words[b] : value*$property*value2]
                }
            }
            # puts "现在的数组为：#{ans}"
        end
     }
     puts "\n"
    }
puts "Byebye!"
rescue Exception => e
    puts e.backtrace.inspect
    puts e.message
end
system "pause"