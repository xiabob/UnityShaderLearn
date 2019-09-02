Shader "Unity Shader Book/Chapter 8/Alpha Test"
{
    Properties
    {
        _Color ("Tint Color", Color) = (1, 1, 1, 1)
        _MainTex ("Main Texture", 2D) = "white" { }
        _Cutout ("Alpha Cutout", Range(0.0, 1.0)) = 0.5
    }
    
    SubShader
    {
        Tags { "Queue" = "AlphaTest" "RenderType" = "TransparentCutout" "IgnoreProjector" = "True" }
        
        Pass
        {
            Tags { "LightMode" = "ForwardBase" }
            
            CGPROGRAM
            
            #pragma vertex vert
            #pragma fragment frag
            #include "Lighting.cginc"
            #include "UnityCG.cginc"
            
            fixed4 _Color;
            sampler2D _MainTex;
            float4 _MainTex_ST;
            fixed _Cutout;
            
            struct a2v
            {
                float4 vertex: POSITION;
                float3 normal: NORMAL;
                float4 texcoord: TEXCOORD0;
            };
            
            struct v2f
            {
                float4 pos: SV_POSITION;
                float3 worldNormal: NORMAL;
                float3 worldPos: TEXCOORD0;
                float2 uv: TEXCOORD1;
            };
            
            v2f vert(a2v v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
                return o;
            }
            
            fixed4 frag(v2f i): SV_TARGET
            {
                fixed3 worldNormal = normalize(i.worldNormal);
                fixed3 worldLightDir = normalize(UnityWorldSpaceLightDir(i.worldPos));
                fixed4 texColor = tex2D(_MainTex, i.uv);
                // alpha test: if not pass, then kill current pixel output
                clip(texColor.a - _Cutout);

                fixed3 albedo = texColor.rgb * _Color.rgb;
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.rgb * albedo;
                fixed3 diffuse = _LightColor0.rgb * albedo * max(0, dot(worldNormal, worldLightDir));
                
                return fixed4(ambient + diffuse, 1);
            }
            
            ENDCG
            
        }
    }
}
