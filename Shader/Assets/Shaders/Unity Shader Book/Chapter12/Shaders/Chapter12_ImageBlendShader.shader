Shader "Hidden/Chapter12_ImageBlendShader"
{
    Properties
    {
        _MainTex ("Origin Texture", 2D) = "white" { }
        _BloomTex ("Bloom Texture", 2D) = "white" { }
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
            float4 _MainTex_TexelSize;
            sampler2D _BloomTex;
            
            struct appdata
            {
                float4 vertex: POSITION;
                float2 uv: TEXCOORD0;
            };
            
            struct v2f
            {
                float4 uv: TEXCOORD0;
                float4 vertex: SV_POSITION;
            };
            
            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv.xy = v.uv; // for main texture
                o.uv.zw = v.uv; 
                // #if UNITY_UV_STARTS_AT_TOP
                //     if (_MainTex_TexelSize.y < 0.0)
                //     {
                //         // for bloom texture，不会自动翻转
                //         o.uv.w = 1.0 - o.uv.w;
                //     }
                // #endif
                
                return o;
            };
            
            fixed4 frag(v2f i): SV_Target
            {
                fixed4 mainColor = tex2D(_MainTex, i.uv.xy);
                fixed4 bloomColor = tex2D(_BloomTex, i.uv.zw);
                return mainColor + bloomColor;
            }
            ENDCG
            
        }
    }
}
