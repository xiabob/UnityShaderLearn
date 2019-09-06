Shader "Unity Shader Book/Chapter 12/EdgeDetectionShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" { }
        _EdgeOnly ("Edge Only", Range(0, 1)) = 0
        _EdgeColor ("Edge Color", Color) = (0, 0, 0, 1)
        _BackgroundColor ("Background Color", Color) = (1, 1, 1, 1)
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
            
            sampler2D _MainTex;
            half4 _MainTex_TexelSize;
            fixed _EdgeOnly;
            fixed4 _EdgeColor;
            fixed4 _BackgroundColor;
            
            struct appdata
            {
                float4 vertex: POSITION;
                float2 uv: TEXCOORD0;
            };
            
            struct v2f
            {
                float4 vertex: SV_POSITION;
                half2 uv[9]: TEXCOORD0;
            };
            
            v2f vert(appdata_img v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                
                half2 uv = v.texcoord;

                o.uv[0] = uv + _MainTex_TexelSize.xy * half2(-1, -1);
                o.uv[1] = uv + _MainTex_TexelSize.xy * half2(0, -1);
                o.uv[2] = uv + _MainTex_TexelSize.xy * half2(1, -1);
                o.uv[3] = uv + _MainTex_TexelSize.xy * half2(-1, 0);
                o.uv[4] = uv + _MainTex_TexelSize.xy * half2(0, 0);
                o.uv[5] = uv + _MainTex_TexelSize.xy * half2(1, 0);
                o.uv[6] = uv + _MainTex_TexelSize.xy * half2(-1, 1);
                o.uv[7] = uv + _MainTex_TexelSize.xy * half2(0, 1);
                o.uv[8] = uv + _MainTex_TexelSize.xy * half2(1, 1);
                
                return o;
            }
            
            // 卷积边缘检测需要使用的是灰度图，只有一个维度值
            fixed grayscale(fixed3 color)
            {
                // Gray = R*0.299 + G*0.587 + B*0.114
                // https://blog.csdn.net/xdrt81y/article/details/8289963
                return color.r * 0.299 + color.g * 0.587 + color.b * 0.114;
            }
            
            half Sobel(v2f i)
            {
                const half Gx[9] = {
                    -1, -2, -1,
                    0, 0, 0,
                    1, 2, 1
                };
                const half Gy[9] = {
                    -1, 0, 1,
                    -2, 0, 2,
                    -1, 0, 1
                };
                
                half texColor;
                half edgeX = 0;
                half edgeY = 0;
                for (int index = 0; index < 9; index ++)
                {
                    texColor = grayscale(tex2D(_MainTex, i.uv[index]));
                    edgeX += texColor * Gx[index];
                    edgeY += texColor * Gy[index];
                }
                
                return 1 - abs(edgeX) - abs(edgeY);
            }
            
            fixed4 frag(v2f i): SV_Target
            {
                half edge = Sobel(i);
                
                fixed4 withEdgeColor = lerp(_EdgeColor, tex2D(_MainTex, i.uv[4]), edge);
                fixed4 onlyEdgeColor = lerp(_EdgeColor, _BackgroundColor, edge);
                return lerp(withEdgeColor, onlyEdgeColor, _EdgeOnly);
            }
            
            ENDCG
            
        }
    }
}
