Shader "Unity Shader Book/Chapter 12/Simple Post Effect"
{
    Properties
    {
        _MainTex ("Base (RGB)", 2D) = "white" { }
        _Brightness ("Brightness", Float) = 1
        _Saturation ("Saturation", Range(-1, 1)) = 0
        _Contrast ("Contrast", Range(0, 1)) = 1
    }
    
    SubShader
    {
        // No culling or depth
        Cull Off ZWrite Off ZTest Always
        
        Pass
        {
            CGPROGRAM
            
            #pragma vertex vert
            #pragma fragment frag
            
            #include "UnityCG.cginc"
            
            fixed4 _Color;
            sampler2D _MainTex;
            float _Brightness;
            float _Saturation;
            float _Contrast;
            
            struct appdata
            {
                float4 vertex: POSITION;
                float2 uv: TEXCOORD0;
            };
            
            struct v2f
            {
                float2 uv: TEXCOORD0;
                float4 vertex: SV_POSITION;
            };
            
            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }
            
            fixed4 frag(v2f i): SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                
                // apply brightness
                fixed3 finalColor = col.rgb * _Brightness;
                
                // apply saturation
                // https://blog.csdn.net/xingyanxiao/article/details/48035537
                fixed rgbMax = max(max(finalColor.r, finalColor.g), finalColor.b);
                fixed rgbMin = min(min(finalColor.r, finalColor.g), finalColor.b);
                half delta = rgbMax - rgbMin;
                if (delta > 0)
                {
                    half value = rgbMax + rgbMin;
                    half l = value * 0.5;
                    
                    half s = delta / value;
                    if(l >= 0.5)
                    {
                        s = delta / (2 - value);
                    }
                    
                    half alpha = s;
                    if(_Saturation >= 0)
                    {
                        if(_Saturation + s < 1)
                        {
                            alpha = 1 - _Saturation;
                        }
                        alpha = 1 / alpha - 1;
                        finalColor = finalColor.rgb + fixed3(finalColor.r - l, finalColor.g - l, finalColor.b - l) * alpha;
                    }
                    else
                    {
                        alpha = _Saturation;
                        finalColor = fixed3(l, l, l) + fixed3(finalColor.r - l, finalColor.g - l, finalColor.b - l) * (1 + alpha);
                    }
                }
                
                // apply contrast
                fixed3 average = fixed3(0.5, 0.5, 0.5);
                finalColor = lerp(average, finalColor, _Contrast);
                
                return fixed4(finalColor, col.a);
            }
            ENDCG
            
        }
    }
    
    Fallback Off
}
