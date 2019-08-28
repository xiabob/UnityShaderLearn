Shader "Unity Shader Book/Chapter 7/Normal Map World Space"
{
    Properties
    {
        _MainTex ("Main Texture", 2D) = "white" { }
        _Color ("Tint Color", Color) = (1, 1, 1, 1)
        _BumpMap ("Normal Map", 2D) = "bump" { }
        _BumpScale ("Bunmp Scale", float) = 1
        _Specular ("Specular Color", Color) = (1, 1, 1, 1)
        _Gloss ("Specular Gloss", Range(8, 200)) = 20
    }
    
    SubShader
    {
        Pass
        {
            Tags { "LightMode" = "ForwardBase" }
            
            CGPROGRAM
            
            #pragma vertex vert
            #pragma fragment frag
            #include "Lighting.cginc"
            #include "UnityCG.cginc"
            
            sampler2D _MainTex;
            float4 _MainTex_ST;
            fixed4 _Color;
            sampler2D _BumpMap;
            float4 _BumpMap_ST;
            float _BumpScale;
            fixed4 _Specular;
            float _Gloss;
            
            struct a2v
            {
                float4 vertex: POSITION;
                float3 normal: NORMAL;
                float4 tangent: TANGENT;
                float4 texcoord: TEXCOORD0;
            };
            
            struct v2f
            {
                float4 position: SV_POSITION;
                float4 uv: TEXCOORD0;
                float4 t2w0: TEXCOORD1;
                float4 t2w1: TEXCOORD2;
                float4 t2w2: TEXCOORD3;
            };
            
            v2f vert(a2v v)
            {
                v2f o;
                o.position = UnityObjectToClipPos(v.vertex);
                
                o.uv.xy = TRANSFORM_TEX(v.texcoord.xy, _MainTex);
                o.uv.zw = TRANSFORM_TEX(v.texcoord.xy, _BumpMap);
                
                float3 worldPosition = mul(unity_ObjectToWorld, v.vertex).xyz;
                float3 worldNormal = UnityObjectToWorldNormal(v.normal);
                float3 worldTangent = UnityObjectToWorldDir(v.tangent.xyz);
                float3 worldBinormal = cross(worldNormal, worldTangent) * v.tangent.w;
                
                // https://blog.csdn.net/liu_if_else/article/details/73604356
                o.t2w0 = float4(worldTangent.x, worldBinormal.x, worldNormal.x, worldPosition.x);
                o.t2w1 = float4(worldTangent.y, worldBinormal.y, worldNormal.y, worldPosition.y);
                o.t2w2 = float4(worldTangent.z, worldBinormal.z, worldNormal.z, worldPosition.z);
                
                return o;
            }
            
            fixed4 frag(v2f v): SV_TARGET
            {
                float3 albedo = tex2D(_MainTex, v.uv.xy) * _Color.rgb;
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.rgb * albedo;
                
                float3 worldPosition = float3(v.t2w0.w, v.t2w1.w, v.t2w2.w);
                fixed3 worldLight = normalize(UnityWorldSpaceLightDir(worldPosition));
                fixed3 viewDir = normalize(UnityWorldSpaceViewDir(worldPosition));
                
                half3 tNormal = UnpackNormal(tex2D(_BumpMap, v.uv.zw));
                tNormal.xy *= _BumpScale;
                tNormal.z = sqrt(1 - saturate(dot(tNormal.xy, tNormal.xy)));
                half3 worldNormal;
                worldNormal.x = dot(v.t2w0.xyz, tNormal);
                worldNormal.y = dot(v.t2w1.xyz, tNormal);
                worldNormal.z = dot(v.t2w2.xyz, tNormal);
                worldNormal = normalize(worldNormal);
                
                fixed3 diffuse = albedo * _LightColor0.rgb * saturate(dot(worldNormal, worldLight));
                
                fixed3 halfDir = normalize(viewDir + worldLight);
                fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(saturate(dot(worldNormal, halfDir)), _Gloss);
                
                fixed3 color = ambient + diffuse + specular;
                
                return fixed4(color, 1);
            }
            
            ENDCG
            
        }
    }
    
    Fallback "Specular"
}
