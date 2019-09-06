Shader "Unity Shader Book/Chapter 12/GaussianBlurShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" { }
        _BlurSize ("Blur Size", float) = 1
    }
    
    SubShader
    {
        // No culling or depth
        Cull Off ZWrite Off ZTest Always
        
        CGINCLUDE
        
        #include "UnityCG.cginc"
        
        sampler2D _MainTex;
        float4 _MainTex_TexelSize;
        float _BlurSize;
        
        struct a2v
        {
            float4 vertex: POSITION;
            half4 texcoord: TEXCOORD0;
        };
        
        struct v2f
        {
            float4 pos: SV_POSITION;
            half2 uv[5]: TEXCOORD0;
        };
        
        v2f vertBlurHorizontal(a2v v)
        {
            v2f o;
            o.pos = UnityObjectToClipPos(v.vertex);
            
            half2 uv = v.texcoord;
            o.uv[0] = uv;
            o.uv[1] = uv + half2(_MainTex_TexelSize.x, 0) * _BlurSize;
            o.uv[2] = uv - half2(_MainTex_TexelSize.x, 0) * _BlurSize;
            o.uv[3] = uv + half2(_MainTex_TexelSize.x * 2.0, 0) * _BlurSize;
            o.uv[4] = uv - half2(_MainTex_TexelSize.x * 2.0, 0) * _BlurSize;
            
            return o;
        }
        
        v2f vertBlurVertical(a2v v)
        {
            v2f o;
            o.pos = UnityObjectToClipPos(v.vertex);
            
            half2 uv = v.texcoord;
            o.uv[0] = uv;
            o.uv[1] = uv + half2(0, _MainTex_TexelSize.y) * _BlurSize;
            o.uv[2] = uv - half2(0, _MainTex_TexelSize.y) * _BlurSize;
            o.uv[3] = uv + half2(0, _MainTex_TexelSize.y * 2.0) * _BlurSize;
            o.uv[4] = uv - half2(0, _MainTex_TexelSize.y * 2.0) * _BlurSize;
            
            return o;
        }
        
        fixed4 fragBlur(v2f i): SV_TARGET
        {
            float weight[3] = {
                0.4026, 0.2442, 0.0545
            };
            fixed3 color = tex2D(_MainTex, i.uv[0]).rgb * weight[0];
            for (int index = 1; index < 3; index ++)
            {
                color += tex2D(_MainTex, i.uv[index]).rgb * weight[index];
                color += tex2D(_MainTex, i.uv[index * 2]).rgb * weight[index];
            }
            return fixed4(color, 1);
        }
        
        ENDCG
        
        Pass
        {
            Name "Gaussian Blur Horizontal"
            
            CGPROGRAM
            
            #pragma vertex vertBlurHorizontal
            #pragma fragment fragBlur
            
            ENDCG
            
        }
        
        Pass
        {
            Name "Gaussian Blur Vertical"
            
            CGPROGRAM
            
            #pragma vertex vertBlurVertical
            #pragma fragment fragBlur
            
            ENDCG
            
        }
    }
}
