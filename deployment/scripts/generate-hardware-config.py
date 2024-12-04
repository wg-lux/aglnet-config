import re
from pathlib import Path

def parse_file(file_path):
    """
    Reads a Nix configuration file and extracts the content as a string.
    """
    with open(file_path, 'r') as file:
        return file.read()

def extract_value(pattern, data, group=1):
    """
    Extracts a value using a regex pattern from the given data.
    """
    match = re.search(pattern, data)
    return match.group(group) if match else None

def extract_uuids(config_data, hardware_data):
    """
    Extracts relevant UUIDs based on the specified mapping.
    """
    # Patterns for UUID extraction
    patterns = {
        "file-system-base-uuid": r'fileSystems\."/"\s*=\s*{\s*device\s*=\s*"/dev/disk/by-uuid/([\w-]+)";',
        "file-system-boot-uuid": r'fileSystems\."/boot"\s*=\s*{\s*device\s*=\s*"/dev/disk/by-uuid/([\w-]+)";',
        "luks-hdd-intern-uuid": r'boot\.initrd\.luks\.devices\."luks-[\w-]+".device\s*=\s*"/dev/disk/by-uuid/([\w-]+)";',
        "luks-swap-uuid": r'boot\.initrd\.luks\.devices\."luks-[\w-]+".device\s*=\s*"/dev/disk/by-uuid/([\w-]+)";',
        "swap-device-uuid": r'swapDevices\s*=\s*\[\s*{\s*device\s*=\s*"/dev/disk/by-uuid/([\w-]+)";'
    }

    # Extract UUIDs
    uuids = {key: extract_value(pattern, hardware_data if "luks" in key else config_data) for key, pattern in patterns.items()}

    return uuids

def extract_kernel_modules(data):
    """
    Extracts kernel modules from the hardware configuration.
    """
    kernel_pattern = re.compile(r'availableKernelModules = \[([^\]]+)\]')
    initrd_kernel_pattern = re.compile(r'kernelModules = \[([^\]]+)\]')
    available_modules = kernel_pattern.search(data)
    initrd_modules = initrd_kernel_pattern.search(data)

    available_modules = available_modules.group(1).split() if available_modules else []
    initrd_modules = initrd_modules.group(1).split() if initrd_modules else []

    return [module.strip('"') for module in available_modules + initrd_modules]

def format_nix_array(array):
    """
    Formats a Python list as a Nix array.
    """
    formatted_items = ' '.join([f'"{item}"' for item in array])
    return f'[{formatted_items}]'

def generate_output(data_dir):
    """
    Generates the output Nix configuration based on the parsed input files.
    """
    config_path = Path(data_dir) / "configuration.nix"
    hardware_path = Path(data_dir) / "hardware-configuration.nix"
    
    if not config_path.exists() or not hardware_path.exists():
        raise FileNotFoundError("Both configuration.nix and hardware-configuration.nix must be present in the directory.")
    
    # Read the configuration files
    config_data = parse_file(config_path)
    hardware_data = parse_file(hardware_path)

    # Extract values
    uuids = extract_uuids(config_data, hardware_data)
    kernel_modules = extract_kernel_modules(hardware_data)

    # Hard-coded user input (in a real script, these would be interactively requested or passed as arguments)
    network_interface = "wlo1"  # Example
    secondary_network_interface = "enp3s0"  # Example
    nvidia_bus_id = "PCI:01:00:0"  # Example
    onboard_graphics_bus_id = "PCI:00:02:0"  # Example
    system_state = "24.11"  # Example

    output = f"""
{{
    network-interface = "{network_interface}"; 
    secondary-network-interface = "{secondary_network_interface}"; 
    nvidiaBusId = "{nvidia_bus_id}"; 
    onboardGraphicBusId = "{onboard_graphics_bus_id}";

    file-system-base-uuid = "{uuids['file-system-base-uuid']}";
    file-system-boot-uuid = "{uuids['file-system-boot-uuid']}";
    swap-device-uuid = "{uuids['swap-device-uuid']}";

    luks-hdd-intern-uuid = "{uuids['luks-hdd-intern-uuid']}";
    luks-swap-uuid = "{uuids['luks-swap-uuid']}";

    kernel-modules = {format_nix_array(kernel_modules)};
    system-state = "{system_state}";
}}
"""
    return output.strip()

def main():
    # Directory containing the configuration.nix and hardware-configuration.nix
    data_dir = input("Enter the path to the directory containing the configuration files: ").strip()
    try:
        output = generate_output(data_dir)
        output_file = Path("generated-config.nix")
        with open(output_file, 'w') as file:
            file.write(output)
        print(f"Generated configuration written to {output_file}")
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    main()
