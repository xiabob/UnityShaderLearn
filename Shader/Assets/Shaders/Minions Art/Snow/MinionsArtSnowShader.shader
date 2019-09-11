Shader "Minions Art/Snow Shader"
{
    Properties
    {
        _Color ("Color", Color) = (1, 1, 1, 1)
        _MainTex ("Albedo (RGB)", 2D) = "white" { }
        _SnowAngle ("Angle of snow buildup", Vector) = (0, 1, 0)
        _SnowColor ("Snow Base Color", Color) = (0.5, 0.5, 0.5, 1)
        _SnowSize ("Snow Amount", Range(-2, 2)) = 1
        _Height ("Snow Height", Range(0, 0.2)) = 0.1
    }
    
    SubShader
    {
        Tags { "RenderType" = "Opaque" }
        LOD 200
        
        CGPROGRAM
        
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard vertex:vert fullforwardshadows
        
        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0
        
        fixed4 _Color;
        sampler2D _MainTex;
        float3 _SnowAngle;
        fixed4 _SnowColor;
        float _SnowSize;
        float _Height;
        
        struct Input
        {
            float2 uv_MainTex;
        };
        
        
        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
        // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)
        
        void vert(inout appdata_full v)
        {
            // float3 normal = UnityObjectToWorldNormal(v.normal);
            float3 snowWorldAngle = mul(unity_ObjectToWorld, _SnowAngle);
            if (dot(v.normal, snowWorldAngle) >= _SnowSize)
            {
                v.vertex.xyz += v.normal.xyz * _Height;
            }
        }
        
        
        void surf(Input IN, inout SurfaceOutputStandard o)
        {
            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            if (dot(o.Normal, _SnowAngle) >= _SnowSize - 0.4)
            {
                o.Albedo = _SnowColor.rgb;
            }
            
            o.Alpha = c.a;
        }
        ENDCG
        
    }
    FallBack "Diffuse"
}
